export const BOARD_SIZE = 8;

export type Player = "white" | "black";
export type GameStatus = "playing" | "won";

export interface Position {
  readonly row: number;
  readonly col: number;
}

export interface Piece {
  readonly player: Player;
}

export interface PlacedPiece {
  readonly position: Position;
  readonly piece: Piece;
}

export interface MoveRecord {
  readonly type: "move";
  readonly from: Position;
  readonly to: Position;
  readonly player: Player;
  readonly captures: readonly Position[];
}

export interface SurrenderRecord {
  readonly type: "surrender";
  readonly player: Player;
}

export type ActionRecord = MoveRecord | SurrenderRecord;

export interface GameState {
  readonly board: readonly (readonly (Piece | null)[])[];
  readonly currentPlayer: Player;
  readonly selected: Position | null;
  readonly lastMove: MoveRecord | null;
  readonly captures: readonly Position[];
  readonly status: GameStatus;
  readonly winner: Player | null;
  readonly history: readonly ActionRecord[];
}

const directions: readonly Position[] = [
  { row: -1, col: 0 }, { row: 0, col: 1 }, { row: 1, col: 0 }, { row: 0, col: -1 },
];

const other = (player: Player): Player => player === "white" ? "black" : "white";
const samePosition = (a: Position, b: Position) => a.row === b.row && a.col === b.col;
const inBounds = (position: Position) => Number.isInteger(position.row) && Number.isInteger(position.col)
  && position.row >= 0 && position.row < BOARD_SIZE && position.col >= 0 && position.col < BOARD_SIZE;
const copyPosition = (position: Position): Position => ({ row: position.row, col: position.col });

function copyBoard(board?: readonly (readonly (Piece | null)[])[]): (Piece | null)[][] {
  return Array.from({ length: BOARD_SIZE }, (_, row) =>
    Array.from({ length: BOARD_SIZE }, (_, col) => board?.[row]?.[col] ? { ...board[row][col]! } : null),
  );
}

export function createState(pieces: readonly PlacedPiece[], currentPlayer: Player = "white"): GameState {
  const board = copyBoard();
  for (const { position, piece } of pieces) {
    if (!inBounds(position) || board[position.row][position.col]) throw new Error("Invalid piece placement");
    board[position.row][position.col] = { ...piece };
  }
  return { board, currentPlayer, selected: null, lastMove: null, captures: [], status: "playing", winner: null, history: [] };
}

export function createInitialState(): GameState {
  const pieces: PlacedPiece[] = [];
  for (let col = 0; col < BOARD_SIZE; col++) {
    pieces.push({ position: { row: 7, col }, piece: { player: "white" } });
    pieces.push({ position: { row: 0, col }, piece: { player: "black" } });
  }
  return createState(pieces);
}

export function getLegalMoves(state: GameState, from: Position): Position[] {
  if (!inBounds(from)) return [];
  const moving = state.board[from.row][from.col];
  if (!moving || moving.player !== state.currentPlayer || state.status !== "playing") return [];
  const moves: Position[] = [];
  for (const direction of directions) {
    let row = from.row + direction.row;
    let col = from.col + direction.col;
    while (inBounds({ row, col }) && !state.board[row][col]) {
      moves.push({ row, col });
      row += direction.row;
      col += direction.col;
    }
  }
  return moves;
}

function hasLegalMove(state: GameState, player: Player): boolean {
  for (let row = 0; row < BOARD_SIZE; row++) for (let col = 0; col < BOARD_SIZE; col++) {
    if (state.board[row][col]?.player === player && getLegalMoves({ ...state, currentPlayer: player }, { row, col }).length) return true;
  }
  return false;
}

export function selectPosition(state: GameState, position: Position | null): GameState {
  if (position !== null && !inBounds(position)) throw new Error("Position out of bounds");
  return { ...state, selected: position && state.board[position.row][position.col]?.player === state.currentPlayer ? copyPosition(position) : null };
}

export function moveTower(state: GameState, from: Position, to: Position): GameState {
  if (state.status !== "playing") throw new Error("Game is over");
  if (!inBounds(from) || !inBounds(to)) throw new Error("Position out of bounds");
  const moving = state.board[from.row][from.col];
  if (!moving || moving.player !== state.currentPlayer) throw new Error("No current player's tower at origin");
  if (!getLegalMoves(state, from).some((position) => samePosition(position, to))) throw new Error("Illegal move");

  const board = copyBoard(state.board);
  board[from.row][from.col] = null;
  board[to.row][to.col] = { ...moving };
  const captured: Position[] = [];
  for (const direction of directions) {
    const run: Position[] = [];
    let row = to.row + direction.row;
    let col = to.col + direction.col;
    while (inBounds({ row, col }) && board[row][col]?.player === other(moving.player)) {
      run.push({ row, col }); row += direction.row; col += direction.col;
    }
    if (run.length && inBounds({ row, col }) && board[row][col]?.player === moving.player) {
      for (const position of run) { board[position.row][position.col] = null; captured.push(position); }
    }
  }
  const record: MoveRecord = { type: "move", from: copyPosition(from), to: copyPosition(to), player: moving.player, captures: captured.map(copyPosition) };
  const opponent = other(moving.player);
  const opponentHasPieces = board.some((row) => row.some((cell) => cell?.player === opponent));
  const won = !opponentHasPieces || !hasLegalMove({ ...state, board }, opponent);
  return {
    board, currentPlayer: won ? moving.player : opponent, selected: null, lastMove: record,
    captures: captured, status: won ? "won" : "playing", winner: won ? moving.player : null,
    history: [...state.history, record],
  };
}

export function surrender(state: GameState): GameState {
  if (state.status !== "playing") throw new Error("Game is over");
  const record: SurrenderRecord = { type: "surrender", player: state.currentPlayer };
  return { ...state, status: "won", winner: other(state.currentPlayer), selected: null, history: [...state.history, record] };
}
