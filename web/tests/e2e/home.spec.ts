import { expect, test } from "@playwright/test";

test("Petteia game page renders", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByRole("heading", { name: "El juego de las torres" })).toBeVisible();
  await expect(page.getByRole("grid", { name: /Tablero de Petteia de 8 por 8/i })).toBeVisible();
  await expect(page.getByRole("button", { name: "Reiniciar" })).toBeVisible();
  await expect(page.getByRole("button", { name: "Rendirse" })).toBeVisible();
});
