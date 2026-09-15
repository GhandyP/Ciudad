import eslint from "@eslint/js";
import tseslint from "typescript-eslint";

export default tseslint.config(
  {
    ignores: [
      "node_modules/**",
      ".next/**",
      "dist/**",
      "build/**",
      "coverage/**",
      "playwright-report/**",
      "test-results/**",
    ],
  },
  eslint.configs.recommended,
  ...tseslint.configs.recommended,
  {
    files: ["**/*.{ts,tsx}"],
    rules: {
      // Type-aware checks are provided by TypeScript rather than ESLint here.
      "no-undef": "off",
    },
  },
  {
    // Keep the existing React Three Fiber controls ref annotation unchanged;
    // this is the only current any required by the starter scene integration.
    files: ["src/scene/PetteiaScene.tsx"],
    rules: {
      "@typescript-eslint/no-explicit-any": "off",
    },
  },
);
