import { defineConfig } from "drizzle-kit";

export default defineConfig({
  out: "./src/db",
  schema: "./database/schemas",
  dialect: "postgresql",
  dbCredentials: {
    url: Deno.env.get("DATABASE_URL")!, // postgresql://[user[:password]@][host][:port]/[dbname]
  },
});
