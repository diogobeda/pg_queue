use Mix.Config

config :stream_pg_kinesis, ecto_repos: [StreamPgKinesis.Repo]

config :stream_pg_kinesis, StreamPgKinesis.Repo,
  database: "pg_kinesis_dev",
  username: "postgres",
  password: "root",
  hostname: "localhost",
  port: "5432"

config :stream_pg_kinesis, PgQueue.Supervisor,
  queues: ["test_event"]
