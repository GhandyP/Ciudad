'use client';

import { Canvas } from "@react-three/fiber";
import { OrbitControls } from "@react-three/drei";
import { useRef } from "react";
import type { GameState, Position } from "../game";

interface PetteiaSceneProps {
  state: GameState;
  legalMoves: readonly Position[];
  onSquare: (position: Position) => void;
  onResetView?: () => void;
}

const positionKey = (position: Position) => `${position.row}-${position.col}`;
const samePosition = (a: Position | null, b: Position) => a !== null && a.row === b.row && a.col === b.col;
const worldPosition = (position: Position): [number, number, number] => [position.col - 3.5, 0, 3.5 - position.row];

function Tower({ player, position, selected, legal, lastMove, onClick }: {
  player: "white" | "black";
  position: Position;
  selected: boolean;
  legal: boolean;
  lastMove: boolean;
  onClick: () => void;
}) {
  const [x, , z] = worldPosition(position);
  const color = player === "white" ? "#f8ead0" : "#292521";
  return (
    <group position={[x, 0.12, z]} onClick={(event) => { event.stopPropagation(); onClick(); }}>
      <mesh castShadow position={[0, 0.38, 0]}>
        <cylinderGeometry args={[0.3, 0.36, 0.7, 16]} />
        <meshStandardMaterial color={color} roughness={0.3} emissive={selected ? "#d65d36" : lastMove ? "#c88728" : "#000000"} emissiveIntensity={selected ? 0.55 : lastMove ? 0.3 : 0} />
      </mesh>
      <mesh castShadow position={[0, 0.78, 0]}>
        <coneGeometry args={[0.3, 0.25, 16]} />
        <meshStandardMaterial color={color} roughness={0.3} />
      </mesh>
      {legal && <mesh rotation={[-Math.PI / 2, 0, 0]} position={[0, 0.04, 0]}>
        <ringGeometry args={[0.35, 0.46, 24]} />
        <meshBasicMaterial color="#e8a83e" />
      </mesh>}
    </group>
  );
}

function Board({ state, legalMoves, onSquare }: Pick<PetteiaSceneProps, "state" | "legalMoves" | "onSquare">) {
  const legalKeys = new Set(legalMoves.map(positionKey));
  const lastMove = state.lastMove;
  return (
    <group rotation={[-0.1, 0, 0]}>
      <mesh receiveShadow position={[0, -0.12, 0]}>
        <boxGeometry args={[8.2, 0.25, 8.2]} />
        <meshStandardMaterial color="#473d31" roughness={0.8} />
      </mesh>
      {state.board.map((row, rowIndex) => row.map((piece, colIndex) => {
        const position = { row: rowIndex, col: colIndex };
        const [x, , z] = worldPosition(position);
        const key = positionKey(position);
        const legal = legalKeys.has(key);
        const highlighted = samePosition(lastMove?.from ?? null, position) || samePosition(lastMove?.to ?? null, position);
        return (
          <group key={key} position={[x, 0, z]}>
            <mesh receiveShadow onClick={(event) => { event.stopPropagation(); onSquare(position); }}>
              <boxGeometry args={[0.98, 0.08, 0.98]} />
              <meshStandardMaterial color={(rowIndex + colIndex) % 2 === 0 ? "#dfcba8" : "#b79361"} emissive={highlighted ? "#c88728" : legal ? "#e8a83e" : "#000000"} emissiveIntensity={highlighted ? 0.28 : legal ? 0.12 : 0} />
            </mesh>
            {piece && <Tower player={piece.player} position={position} selected={samePosition(state.selected, position)} legal={legal} lastMove={highlighted} onClick={() => onSquare(position)} />}
            {legal && !piece && <mesh rotation={[-Math.PI / 2, 0, 0]} position={[0, 0.06, 0]} onClick={(event) => { event.stopPropagation(); onSquare(position); }}>
              <circleGeometry args={[0.13, 16]} />
              <meshBasicMaterial color="#e8a83e" />
            </mesh>}
          </group>
        );
      }))}
    </group>
  );
}

export default function PetteiaScene({ state, legalMoves, onSquare }: PetteiaSceneProps) {
  const controls = useRef<any>(null);
  return (
    <div className="scene-frame" aria-label="Vista 3D interactiva del tablero de Petteia">
      <Canvas
          shadows
          camera={{ position: [0, 7.8, 7.8], fov: 42 }}
          fallback={(
            <div className="scene-fallback" role="status">
              <strong>La vista 3D no está disponible.</strong>
              <span>Usá el tablero HTML accesible para jugar.</span>
            </div>
          )}
        >
        <color attach="background" args={["#f5f1e8"]} />
        <ambientLight intensity={1.2} />
        <directionalLight castShadow intensity={2.2} position={[4, 8, 5]} shadow-mapSize={[1024, 1024]} />
        <Board state={state} legalMoves={legalMoves} onSquare={onSquare} />
        <OrbitControls ref={controls} enablePan={false} minDistance={6} maxDistance={15} target={[0, 0, 0]} />
      </Canvas>
      <button type="button" className="scene-reset" onClick={() => controls.current?.reset()}>Restablecer vista</button>
    </div>
  );
}
