import type { ActionRecord, GameState, MoveRecord, Player, Position } from "../game";

export const GAME_STORAGE_KEY = "petteia.current-game";
export const GAME_STATE_SCHEMA_VERSION = 2;
const LEGACY_GAME_STATE_SCHEMA_VERSION = 1;

type StoredGameStates = {
  version: typeof GAME_STATE_SCHEMA_VERSION;
  states: GameState[];
};
type LegacyStoredGameState = {
  version: typeof LEGACY_GAME_STATE_SCHEMA_VERSION;
  state: GameState;
};

const isPlayer = (value: unknown): value is Player => value === "white" || value === "black";
const isPosition = (value: unknown): value is Position => {
  if (!value || typeof value !== "object") return false;
  const position = value as Position;
  return Number.isInteger(position.row) && Number.isInteger(position.col)
    && position.row >= 0 && position.row < 8 && position.col >= 0 && position.col < 8;
};
const isMoveRecord = (value: unknown): value is MoveRecord => {
  if (!value || typeof value !== "object") return false;
  const record = value as MoveRecord;
  return record.type === "move" && isPosition(record.from) && isPosition(record.to)
    && isPlayer(record.player) && Array.isArray(record.captures) && record.captures.every(isPosition);
};
const isActionRecord = (value: unknown): value is ActionRecord => {
  if (!value || typeof value !== "object") return false;
  const record = value as ActionRecord;
  return isMoveRecord(record) || (record.type === "surrender" && isPlayer(record.player));
};

function isGameState(value: unknown): value is GameState {
  if (!value || typeof value !== "object") return false;
  const state = value as GameState;
  return Array.isArray(state.board) && state.board.length === 8
    && state.board.every((row) => Array.isArray(row) && row.length === 8
      && row.every((piece) => piece === null || (typeof piece === "object" && isPlayer((piece as { player?: unknown }).player))))
    && isPlayer(state.currentPlayer)
    && (state.selected === null || isPosition(state.selected))
    && (state.lastMove === null || isMoveRecord(state.lastMove))
    && Array.isArray(state.captures) && state.captures.every(isPosition)
    && ((state.status === "playing" && state.winner === null)
      || (state.status === "won" && isPlayer(state.winner)))
    && Array.isArray(state.history) && state.history.every(isActionRecord);
}

/** Encode a single snapshot using the current stack schema. */
export function encodeGameState(state: GameState): string {
  return encodeGameStates([state]);
}

/** Encode the complete UI snapshot stack without accessing browser APIs. */
export function encodeGameStates(states: readonly GameState[]): string {
  const payload: StoredGameStates = { version: GAME_STATE_SCHEMA_VERSION, states: [...states] };
  return JSON.stringify(payload);
}

/** Decode and validate a versioned stack; invalid data is intentionally treated as absent. */
export function decodeGameStates(payload: string): GameState[] | null {
  try {
    const parsed: unknown = JSON.parse(payload);
    if (!parsed || typeof parsed !== "object") return null;
    const version = (parsed as { version?: unknown }).version;
    if (version === GAME_STATE_SCHEMA_VERSION) {
      const states = (parsed as { states?: unknown }).states;
      return Array.isArray(states) && states.length > 0 && states.every(isGameState) ? states : null;
    }
    if (version === LEGACY_GAME_STATE_SCHEMA_VERSION) {
      const state = (parsed as LegacyStoredGameState).state;
      return isGameState(state) ? [state] : null;
    }
    return null;
  } catch {
    return null;
  }
}

/** Decode the latest snapshot, including the version 1 single-state migration. */
export function decodeGameState(payload: string): GameState | null {
  const states = decodeGameStates(payload);
  return states ? states[states.length - 1] : null;
}

function storage(): Storage | null {
  try {
    return typeof window !== "undefined" && window.localStorage ? window.localStorage : null;
  } catch {
    return null;
  }
}

export function loadGameStates(): GameState[] | null {
  try {
    const value = storage()?.getItem(GAME_STORAGE_KEY);
    return value === null || value === undefined ? null : decodeGameStates(value);
  } catch {
    return null;
  }
}

export function loadGameState(): GameState | null {
  const states = loadGameStates();
  return states ? states[states.length - 1] : null;
}

export function saveGameStates(states: readonly GameState[]): boolean {
  try {
    const available = storage();
    if (!available || states.length === 0 || !states.every(isGameState)) return false;
    available.setItem(GAME_STORAGE_KEY, encodeGameStates(states));
    return true;
  } catch {
    return false;
  }
}

export function saveGameState(state: GameState): boolean {
  return saveGameStates([state]);
}

export function clearGameState(): boolean {
  try {
    const available = storage();
    if (!available) return false;
    available.removeItem(GAME_STORAGE_KEY);
    return true;
  } catch {
    return false;
  }
}
