import { defineConfig } from "drizzle-kit";

export default defineConfig({
  out: "./src/db",
  schema: "./src/db/schema.ts",
  dialect: "postgresql",
  dbCredentials: {
    url: Deno.env.get("DATABASE_URL")!, // postgresql://[user[:password]@][host][:port]/[dbname]
  },
});
