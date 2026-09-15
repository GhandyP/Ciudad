'use client';

import { useEffect, useMemo, useRef, useState } from "react";
    import PetteiaScene from "../../scene/PetteiaScene";
import {
  BOARD_SIZE,
  createInitialState,
  getLegalMoves,
  moveTower,
  selectPosition,
  surrender,
  type GameState,
  type Player,
  type Position,
} from "../../game";
import { loadGameStates, saveGameStates } from "../../services/gamePersistence";

const files = ["a", "b", "c", "d", "e", "f", "g", "h"];
const playerNames: Record<Player, string> = { white: "Blancas", black: "Negras" };
const positionKey = (position: Position) => `${position.row}-${position.col}`;
const samePosition = (a: Position | null, b: Position) =>
  a !== null && b !== null && a.row === b.row && a.col === b.col;

export default function PetteiaGame() {
  const [states, setStates] = useState<GameState[]>([createInitialState()]);
  const [surrenderPending, setSurrenderPending] = useState(false);
  const [restored, setRestored] = useState(false);
  const squareRefs = useRef<Record<string, HTMLButtonElement | null>>({});

  useEffect(() => {
    const savedStates = loadGameStates();
    if (savedStates) setStates(savedStates);
    setRestored(true);
  }, []);

  const state = states[states.length - 1];

  useEffect(() => {
    if (restored) saveGameStates(states);
  }, [restored, states]);
  const legalMoves = useMemo(
    () => (state.selected ? getLegalMoves(state, state.selected) : []),
    [state],
  );
  const legalMoveKeys = new Set(legalMoves.map(positionKey));

  const commit = (next: GameState) => setStates((previous) => [...previous, next]);
  const handleSquareKeyDown = (event: React.KeyboardEvent<HTMLButtonElement>, position: Position) => {
    const deltas: Record<string, Position> = {
      ArrowUp: { row: -1, col: 0 },
      ArrowRight: { row: 0, col: 1 },
      ArrowDown: { row: 1, col: 0 },
      ArrowLeft: { row: 0, col: -1 },
    };
    const delta = deltas[event.key];
    if (!delta) return;
    event.preventDefault();
    const next = { row: position.row + delta.row, col: position.col + delta.col };
    if (next.row >= 0 && next.row < BOARD_SIZE && next.col >= 0 && next.col < BOARD_SIZE) {
      squareRefs.current[positionKey(next)]?.focus();
    }
  };
  const handleSquare = (position: Position) => {
    if (state.status !== "playing") return;
    const piece = state.board[position.row][position.col];
    if (state.selected && legalMoveKeys.has(positionKey(position))) {
      commit(moveTower(state, state.selected, position));
      return;
    }
    if (piece?.player === state.currentPlayer) {
      commit(selectPosition(state, position));
    } else if (state.selected) {
      commit(selectPosition(state, null));
    }
  };

  const reset = () => {
    setStates([createInitialState()]);
    setSurrenderPending(false);
  };
  const undo = () => {
    if (states.length > 1) setStates((previous) => previous.slice(0, -1));
  };
  const confirmSurrender = () => {
    commit(surrender(state));
    setSurrenderPending(false);
  };

  return (
    <main className="game-shell">
      <header className="game-header">
        <div>
          <p className="eyebrow">Petteia</p>
          <h1>El juego de las torres</h1>
          <p className="intro">Dos jugadores. Una estrategia. Capturá todas las torres rivales.</p>
        </div>
        <div className="turn-card" aria-live="polite">
          <span>Turno actual</span>
          <strong>{state.status === "won" ? "Partida terminada" : playerNames[state.currentPlayer]}</strong>
        </div>
      </header>

      <div className="game-layout">
        <section aria-labelledby="scene-title">
              <h2 id="scene-title" className="section-title">Vista 3D del tablero</h2>
              <PetteiaScene state={state} legalMoves={legalMoves} onSquare={handleSquare} />
              <p className="board-help">Hacé clic en una torre para seleccionarla. Arrastrá para girar y usá la rueda para acercar.</p>
            </section>

            <section className="accessible-board-section" aria-labelledby="board-title">
          <h2 id="board-title" className="section-title">Tablero HTML accesible</h2>
              <p className="board-help">Alternativa accesible: usá estas casillas y sus etiquetas para jugar sin la vista 3D.</p>
          <div className="board-wrap">
            <div className="file-labels" aria-hidden="true">
              <span />{files.map((file) => <span key={file}>{file}</span>)}
            </div>
            <div className="board-row">
              <div className="rank-labels" aria-hidden="true">
                {Array.from({ length: BOARD_SIZE }, (_, row) => <span key={row}>{BOARD_SIZE - row}</span>)}
              </div>
              <div className="board" role="grid" aria-label="Tablero de Petteia de 8 por 8">
                {state.board.map((row, rowIndex) => row.map((piece, colIndex) => {
                  const position = { row: rowIndex, col: colIndex };
                  const isSelected = samePosition(state.selected, position);
                  const isLegal = legalMoveKeys.has(positionKey(position));
                  const coordinate = `${files[colIndex]}${BOARD_SIZE - rowIndex}`;
                  const content = piece ? `torre ${playerNames[piece.player].toLowerCase()}` : isLegal ? "movimiento legal" : "casilla vacía";
                  return (
                    <button
                      type="button"
                      ref={(element) => { squareRefs.current[positionKey(position)] = element; }}
                      className={`square ${piece?.player ?? "empty"} ${isSelected ? "selected" : ""} ${isLegal ? "legal" : ""}`}
                      key={coordinate}
                      aria-label={`${coordinate}: ${content}${isSelected ? ", seleccionada" : ""}`}
                      aria-pressed={isSelected}
                          tabIndex={state.selected ? (isSelected ? 0 : -1) : piece?.player === state.currentPlayer ? 0 : -1}
                      onClick={() => handleSquare(position)}
                          onKeyDown={(event) => handleSquareKeyDown(event, position)}
                    >
                      {piece ? <span aria-hidden="true">{piece.player === "white" ? "○" : "●"}</span> : isLegal ? <span aria-hidden="true">·</span> : null}
                    </button>
                  );
                }))}
              </div>
            </div>
          </div>
          <p className="board-help">Seleccioná una torre para ver sus movimientos legales.</p>
        </section>

        <aside className="game-panel">
          <section className="status-panel" aria-live="polite">
            <h2>Estado de la partida</h2>
            {state.status === "won" ? (
              <p className="winner">Ganaron las {playerNames[state.winner!].toLowerCase()}.</p>
            ) : <p>Juegan las <strong>{playerNames[state.currentPlayer].toLowerCase()}</strong>.</p>}
            {state.captures.length > 0 && state.lastMove && (
              <p className="capture-feedback">Se capturaron {state.captures.length} torre{state.captures.length === 1 ? "" : "s"} en el último movimiento.</p>
            )}
          </section>

          <section className="controls" aria-label="Controles de partida">
            <button type="button" onClick={reset}>Reiniciar</button>
            <button type="button" onClick={undo} disabled={states.length === 1}>Deshacer</button>
            <button type="button" className="danger" onClick={() => setSurrenderPending(true)} disabled={state.status === "won"}>Rendirse</button>
          </section>

          {surrenderPending && (
            <section className="confirm-box" role="alertdialog" aria-labelledby="surrender-title">
              <h2 id="surrender-title">¿Querés rendirte?</h2>
              <p>La victoria será para las {playerNames[state.currentPlayer === "white" ? "black" : "white"].toLowerCase()}.</p>
              <div className="confirm-actions">
                <button type="button" className="danger" onClick={confirmSurrender}>Confirmar rendición</button>
                <button type="button" onClick={() => setSurrenderPending(false)}>Cancelar</button>
              </div>
            </section>
          )}

          <section className="history" aria-labelledby="history-title">
            <h2 id="history-title">Historial de movimientos</h2>
            {state.history.length === 0 ? <p className="muted">Todavía no hay movimientos.</p> : (
              <ol>
                {state.history.map((record, index) => record.type === "surrender" ? (
                  <li key={index}>{playerNames[record.player]} se rindieron</li>
                ) : <li key={index}>{playerNames[record.player]}: {files[record.from.col]}{BOARD_SIZE - record.from.row} → {files[record.to.col]}{BOARD_SIZE - record.to.row}{record.captures.length ? ` (${record.captures.length} captura${record.captures.length === 1 ? "" : "s"})` : ""}</li>)}
              </ol>
            )}
          </section>
        </aside>
      </div>
    </main>
  );
}
