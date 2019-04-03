defmodule SimpleInOut do
  def fetch_token(code) do
    SimpleInOut.Token.fetch(code)
  end
end
