import { describe, expect, it } from "vitest";
import {
  BOARD_SIZE,
  createInitialState,
  createState,
  getLegalMoves,
  moveTower,
  selectPosition,
  surrender,
  type Piece,
  type Position,
} from "../../../src/game";

const p = (row: number, col: number): Position => ({ row, col });
const piece = (player: "white" | "black"): Piece => ({ player });

function stateWith(pieces: Array<[Position, "white" | "black"]>, currentPlayer: "white" | "black" = "white") {
  return createState(
    pieces.map(([position, player]) => ({ position, piece: piece(player) })),
    currentPlayer,
  );
}

describe("Petteia domain engine", () => {
  it("creates the 8x8 initial setup with white to move", () => {
    const state = createInitialState();
    expect(BOARD_SIZE).toBe(8);
    expect(state.currentPlayer).toBe("white");
    expect(state.status).toBe("playing");
    expect(state.board[7].every((cell) => cell?.player === "white")).toBe(true);
    expect(state.board[0].every((cell) => cell?.player === "black")).toBe(true);
    expect(state.board.slice(1, 7).flat().every((cell) => cell === null)).toBe(true);
  });

  it("allows positive horizontal and vertical slides only", () => {
    const state = stateWith([[p(3, 3), "white"]]);
    expect(getLegalMoves(state, p(3, 3))).toEqual(
      expect.arrayContaining([p(3, 0), p(3, 7), p(0, 3), p(7, 3)]),
    );
    expect(getLegalMoves(state, p(3, 3))).not.toContainEqual(p(2, 2));
    expect(() => moveTower(state, p(3, 3), p(2, 2))).toThrow();
    expect(() => moveTower(state, p(3, 3), p(3, 3))).toThrow();
  });

  it("rejects blocked paths, occupied destinations, out-of-turn and out-of-bounds moves", () => {
    const state = stateWith([
      [p(3, 3), "white"], [p(3, 5), "white"], [p(1, 3), "black"],
    ]);
    expect(() => moveTower(state, p(3, 3), p(3, 6))).toThrow();
    expect(() => moveTower(state, p(3, 3), p(3, 5))).toThrow();
    expect(() => moveTower(state, p(3, 3), p(-1, 3))).toThrow();
    expect(() => moveTower(state, p(1, 3), p(1, 4))).toThrow();
  });

  it("captures contiguous enemy runs in all four directions", () => {
    const state = stateWith([
      [p(3, 0), "white"], [p(3, 6), "white"],
      [p(0, 3), "white"], [p(6, 3), "white"],
      [p(3, 4), "black"], [p(3, 5), "black"],
      [p(1, 3), "black"], [p(2, 3), "black"], [p(4, 3), "black"], [p(5, 3), "black"],
    ]);
    const result = moveTower(state, p(3, 0), p(3, 3));
    expect(result.captures).toEqual([
      p(2, 3), p(1, 3),
      p(3, 4), p(3, 5),
      p(4, 3), p(5, 3),
    ]);
  });

  it("does not capture an enemy run with an empty gap before the friendly bracket", () => {
    const state = stateWith([
      [p(3, 0), "white"], [p(3, 5), "white"], [p(3, 3), "black"],
    ]);
    const result = moveTower(state, p(3, 0), p(3, 2));

    expect(result.captures).toEqual([]);
    expect(result.board[3][3]).toEqual(piece("black"));
  });

  it("captures an enemy run on the remaining horizontal direction", () => {
    const state = stateWith([[p(3, 7), "white"], [p(3, 2), "black"], [p(3, 1), "white"]]);
    expect(moveTower(state, p(3, 7), p(3, 3)).captures).toEqual([p(3, 2)]);
  });

  it("resolves multiple captures deterministically and does not capture unrelated groups", () => {
    const state = stateWith([
      [p(3, 1), "white"], [p(3, 6), "white"], [p(1, 3), "white"], [p(6, 3), "white"],
      [p(3, 3), "black"], [p(3, 4), "black"], [p(3, 5), "black"], [p(1, 1), "black"],
    ]);
    const result = moveTower(state, p(3, 1), p(3, 2));
    expect(result.captures).toEqual([p(3, 3), p(3, 4), p(3, 5)]);
    expect(result.board[1][1]).toEqual(piece("black"));
  });

  it("wins when the opponent has no towers or no legal moves", () => {
    const noPieces = moveTower(stateWith([
      [p(1, 0), "white"], [p(2, 1), "black"], [p(3, 1), "white"],
    ]), p(1, 0), p(1, 1));
    expect(noPieces.status).toBe("won");
    expect(noPieces.winner).toBe("white");

    const immobile = moveTower(stateWith([
      [p(3, 1), "white"], [p(0, 0), "white"], [p(2, 0), "white"], [p(1, 1), "white"], [p(1, 0), "black"],
    ]), p(3, 1), p(3, 2));
    expect(immobile.status).toBe("won");
    expect(immobile.winner).toBe("white");
  });

  it("switches turns, records history, supports selection, and preserves prior state", () => {
    const state = stateWith([[p(7, 0), "white"], [p(0, 0), "black"]]);
    const selected = selectPosition(state, p(7, 0));
    const next = moveTower(selected, p(7, 0), p(6, 0));
    expect(next.currentPlayer).toBe("black");
    expect(next.lastMove?.from).toEqual(p(7, 0));
    expect(next.history).toHaveLength(1);
    expect(selected.board[7][0]).toEqual(piece("white"));
    expect(state.selected).toBeNull();
    expect(next.selected).toBeNull();
  });

  it("ends immediately when the current player surrenders", () => {
    const state = stateWith([[p(7, 0), "white"], [p(0, 0), "black"]]);
    const result = surrender(state);
    expect(result.status).toBe("won");
    expect(result.winner).toBe("black");
    expect(result.history[0]?.type).toBe("surrender");
    expect(() => surrender(result)).toThrow();
  });
});
