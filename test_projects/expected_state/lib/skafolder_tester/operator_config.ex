defmodule SkafolderTester.OperatorConfig do
  use VBT.Provider,
    source: VBT.Provider.SystemEnv,
    params: [
      {:db_url, dev: dev_db_url()},
      {:db_pool_size, type: :integer, default: 10},
      {:db_ssl, type: :boolean, default: false}
    ]

  if Mix.env() in ~w/dev test/a do
    defp dev_db_url do
      db_host = System.get_env("PGHOST", "localhost")
      db_name = if ci?(), do: "skafolder_tester_test", else: "skafolder_tester_#{unquote(Mix.env())}"
      "postgresql://postgres:postgres@#{db_host}/#{db_name}"
    end

    defp ci?, do: System.get_env("CI") == "true"
  end
end
