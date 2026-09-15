import { describe, expect, it } from "vitest";

describe("test harness", () => {
  it("runs against the generated Vinext app", () => {
    expect(process.env.NODE_ENV).toBe("test");
  });
});
