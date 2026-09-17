import { expect, test, type Page } from "@playwright/test";

const square = (page: Page, coordinate: string) =>
  page.getByRole("button", { name: new RegExp(`^${coordinate}:`) });

async function startClean(page: Page) {
  await page.goto("/");
  await page.evaluate(() => localStorage.clear());
  await page.reload();
  // Wait for React hydration: SSR markup is already present, but click and key
  // handlers only work once the client component has mounted.
  await page.waitForSelector("html[data-petteia-ready='true']");
  await expect(square(page, "a1")).toHaveAccessibleName("a1: torre blancas");
}

async function move(page: Page, from: string, to: string) {
  await square(page, from).click();
  await square(page, to).click();
}

test("selecting a white tower shows legal moves and marks it selected", async ({ page }) => {
  await startClean(page);

  await square(page, "a1").click();

  await expect(square(page, "a1")).toHaveAccessibleName("a1: torre blancas, seleccionada");
  await expect(page.getByRole("button", { name: /movimiento legal/ }).first()).toBeVisible();
});

test("making the first move updates the board, turn, and history", async ({ page }) => {
  await startClean(page);

  await move(page, "a1", "a2");

  await expect(square(page, "a1")).toHaveAccessibleName("a1: casilla vacía");
  await expect(square(page, "a2")).toHaveAccessibleName("a2: torre blancas");
  await expect(page.getByText("Juegan las negras.")).toBeVisible();
  await expect(page.getByText("Blancas: a1 → a2")).toBeVisible();
});

test("undo returns to the previous position", async ({ page }) => {
  await startClean(page);

  await move(page, "a1", "a2");
  await page.getByRole("button", { name: "Deshacer" }).click();

  // Undo restores the snapshot immediately before the move, which kept a1
  // selected; the tower is back on its original square and still selected.
  await expect(square(page, "a1")).toHaveAccessibleName("a1: torre blancas, seleccionada");
  // a2 is empty again, so it is offered as a legal destination for a1.
  await expect(square(page, "a2")).toHaveAccessibleName("a2: movimiento legal");
  await expect(page.getByText("Juegan las blancas.")).toBeVisible();
  await expect(page.getByText("Todavía no hay movimientos.")).toBeVisible();
});

test("a blocking capture removes the tower and shows capture feedback", async ({ page }) => {
  await startClean(page);

  // Build a sandwich: white a6, black a5, then white a4 captures a5.
  await move(page, "a1", "a6");
  await move(page, "b8", "b6");
  await move(page, "b1", "b4");
  await move(page, "b6", "b5");
  await move(page, "c1", "c4");
  await move(page, "b5", "a5");
  await move(page, "b4", "a4");

  await expect(square(page, "a5")).toHaveAccessibleName("a5: casilla vacía");
  await expect(page.getByText("Se capturaron 1 torre en el último movimiento.")).toBeVisible();
  await expect(page.getByText(/Blancas: b4 → a4 \(1 captura\)/)).toBeVisible();
});

test("surrender requires confirmation and ends the game", async ({ page }) => {
  await startClean(page);

  await page.getByRole("button", { name: "Rendirse" }).click();
  await expect(page.getByRole("button", { name: "Confirmar rendición" })).toBeVisible();
  await page.getByRole("button", { name: "Confirmar rendición" }).click();

  await expect(page.getByText("Ganaron las negras.")).toBeVisible();
  await expect(page.getByText("Partida terminada")).toBeVisible();
});

test("a move persists across reload", async ({ page }) => {
  await startClean(page);

  await move(page, "a1", "a2");

  // The snapshot stack is persisted by an effect after the move commits; wait
  // for the written payload so the reload does not race the save.
  await expect
    .poll(async () =>
      page.evaluate(() => {
        const raw = localStorage.getItem("petteia.current-game");
        if (!raw) return 0;
        try {
          return (JSON.parse(raw) as { states?: unknown[] }).states?.length ?? 0;
        } catch {
          return 0;
        }
      }),
    )
    .toBeGreaterThanOrEqual(3);

  await page.reload();
  // Wait for hydration and the localStorage restore before asserting state.
  await page.waitForSelector("html[data-petteia-ready='true']");

  await expect(square(page, "a2")).toHaveAccessibleName("a2: torre blancas");
  await expect(page.getByText("Juegan las negras.")).toBeVisible();
  await expect(page.getByText("Blancas: a1 → a2")).toBeVisible();
});

test("arrow-key navigation focuses the adjacent square", async ({ page }) => {
  await startClean(page);

  await square(page, "a1").focus();
  await page.keyboard.press("ArrowUp");

  await expect(square(page, "a2")).toBeFocused();
});
