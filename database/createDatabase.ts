import pg from "npm:pg";

const createDatabase = async () => {
  const { Client } = pg;

  let client = new Client({
    user: Deno.env.get("DATABASE_USER"),
    password: Deno.env.get("DATABASE_PWD"),
    host: Deno.env.get("DATABASE_HOST"),
    port: Deno.env.get("DATABASE_PORT"),
  });

  try {
    await client.connect();
    console.log("--------------------------------------");
    console.log("Etapa 1 - Criação do banco de dados");
    const dbExists = await client.query(
      `SELECT EXISTS(SELECT datname FROM pg_catalog.pg_database WHERE datname = 'geplanes_bsc');`,
    );
    if (dbExists.rows[0]?.exists === true) {
      console.log("Banco de dados já existe. Pulando etapa...");
    } else {
      await client.query(`CREATE DATABASE geplanes_bsc WITH
                              OWNER = postgres
                              ENCODING = 'UTF8'
                              LOCALE_PROVIDER = 'libc'
                              IS_TEMPLATE = False;`);
      console.log("Banco de dados criado com sucesso!");
    }
    // await client.end();

    // client = new Client({
    //   user: Deno.env.get("DATABASE_USER"),
    //   password: Deno.env.get("DATABASE_PWD"),
    //   host: Deno.env.get("DATABASE_HOST"),
    //   port: Deno.env.get("DATABASE_PORT"),
    //   database: "geplanes_bsc",
    // });
    // await client.connect();
    // console.log("--------------------------------------");
    // console.log("Etapa 2 - Criação do schema");
    // const schemaExists = await client.query(
    //   `SELECT EXISTS(select schema_name FROM information_schema.schemata WHERE schema_name = 'geplanes');`,
    // );
    // if (schemaExists.rows[0]?.exists === true) {
    //   console.log("Schema já existe. Pulando etapa...");
    // } else {
    //   await client.query(`CREATE SCHEMA IF NOT EXISTS geplanes;`);
    //   console.log("Schema criado com sucesso no banco de dados geplanes_bsc!");
    // }
    console.log("--------------------------------------");
    console.log("\nConfiguração concluída com sucesso!");
  } catch (e: unknown) {
    console.error("\nErro durante a criação do banco de dados!");
    console.error(e);
  } finally {
    await client.end();
  }
};

createDatabase();
