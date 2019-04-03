defmodule SimpleInOut.Statuses do
  @base_path Keyword.get(Application.get_env(:time_tracker, :simple_in_out), :base_path)

  def today(token) do
    url = @base_path <> "/api/v4/statuses"

    created_at = get_interval()

    response = HTTPoison.get(url, [{"authorization", token}], params: %{created_at: created_at})

    IO.inspect response

    case response do
      {:ok, %{body: body, status_code: 200}} ->
        Poison.decode!(body)["statuses"]
        |> Enum.map(&format_status/1)

      {:ok, %{status_code: status_code, body: body}} ->
        raise SimpleInOut.Error.UpstreamError, "Status: #{status_code}, body: #{body}"

      {:error, error} ->
        raise SimpleInOut.Error.ParseError
    end
  end

  def format_status(%{"status" => status, "created_at" => created_at, "comment" => comment}) do
    %{status: status, time: created_at, message: comment}
  end

  def get_interval do
    start_time =
      DateTime.utc_now()
      # 12 hours in seconds
      |> DateTime.add(-12 * 60 * 60)
      |> DateTime.to_unix()

    end_time =
      DateTime.utc_now()
      |> DateTime.to_unix()

    "#{start_time}..#{end_time}"
  end
end
