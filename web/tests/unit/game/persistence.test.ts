import { describe, expect, it, vi } from "vitest";
import {
  createInitialState,
  createState,
  moveTower,
  type GameState,
} from "../../../src/game";
import {
  GAME_STATE_SCHEMA_VERSION,
  GAME_STORAGE_KEY,
  clearGameState,
  decodeGameState,
  decodeGameStates,
  encodeGameState,
  encodeGameStates,
  loadGameState,
  loadGameStates,
  saveGameState,
  saveGameStates,
} from "../../../src/services/gamePersistence";

const storage = () => {
  const values = new Map<string, string>();
  return {
    getItem: vi.fn((key: string) => values.get(key) ?? null),
    setItem: vi.fn((key: string, value: string) => values.set(key, value)),
    removeItem: vi.fn((key: string) => values.delete(key)),
  } as unknown as Storage;
};

const withStorage = <T,>(value: Storage, callback: () => T): T => {
  Object.defineProperty(globalThis, "window", { configurable: true, value: { localStorage: value } });
  return callback();
};

describe("versioned game persistence", () => {
  it("round-trips the complete initial state", () => {
    const state = createInitialState();
    expect(decodeGameState(encodeGameState(state))).toEqual(state);
  });

  it("round-trips moved and captured state including history", () => {
    const state = createState([
      { position: { row: 7, col: 0 }, piece: { player: "white" } },
      { position: { row: 0, col: 0 }, piece: { player: "black" } },
      { position: { row: 6, col: 1 }, piece: { player: "black" } },
      { position: { row: 6, col: 2 }, piece: { player: "white" } },
    ]);
    const moved = moveTower(state, { row: 7, col: 0 }, { row: 6, col: 0 });
    expect(moved.captures).toEqual([{ row: 6, col: 1 }]);
    expect(decodeGameState(encodeGameState(moved))).toEqual(moved);
  });

  it.each(["not json", JSON.stringify({ version: GAME_STATE_SCHEMA_VERSION }), JSON.stringify({ version: GAME_STATE_SCHEMA_VERSION, state: {} })])(
    "rejects malformed payload %s",
    (payload) => expect(decodeGameState(payload)).toBeNull(),
  );

  it("rejects semantically invalid winner and status combinations", () => {
    const state = createInitialState();
    expect(decodeGameState(JSON.stringify({ version: 1, state: { ...state, status: "won", winner: null } }))).toBeNull();
    expect(decodeGameState(JSON.stringify({ version: 1, state: { ...state, status: "playing", winner: "white" } }))).toBeNull();
  });

  it("rejects unsupported game status values even with a valid winner", () => {
    const state = createInitialState();
    expect(decodeGameState(JSON.stringify({
      version: 1,
      state: { ...state, status: "paused", winner: "white" },
    }))).toBeNull();
  });

  it("restores a complete snapshot stack and migrates version 1", () => {
    const initial = createInitialState();
    const moved = moveTower(initial, { row: 7, col: 0 }, { row: 6, col: 0 });
    expect(decodeGameStates(encodeGameStates([initial, moved]))).toEqual([initial, moved]);
    expect(decodeGameStates(JSON.stringify({ version: 1, state: moved }))).toEqual([moved]);
  });

  it("rejects unsupported schema versions", () => {
    const payload = JSON.stringify({ version: GAME_STATE_SCHEMA_VERSION + 1, state: createInitialState() });
    expect(decodeGameState(payload)).toBeNull();
  });

  it("fails safely when browser storage is unavailable", () => {
    Object.defineProperty(globalThis, "window", { configurable: true, value: undefined });
    expect(loadGameState()).toBeNull();
    expect(saveGameState(createInitialState())).toBe(false);
    expect(saveGameStates([createInitialState()])).toBe(false);
    expect(clearGameState()).toBe(false);
  });

  it("uses a stable key and safely loads, saves, and clears", () => {
    const browserStorage = storage();
    withStorage(browserStorage, () => {
      const state: GameState = createInitialState();
      expect(saveGameState(state)).toBe(true);
      expect(browserStorage.setItem).toHaveBeenCalledWith(GAME_STORAGE_KEY, expect.any(String));
      expect(loadGameState()).toEqual(state);
      expect(saveGameStates([state, moveTower(state, { row: 7, col: 0 }, { row: 6, col: 0 })])).toBe(true);
      expect(loadGameStates()).toHaveLength(2);
      expect(clearGameState()).toBe(true);
      expect(loadGameState()).toBeNull();
    });
  });
});
