defmodule ServerWeb.JWTManager do
  def create_token(user_id, role, xsrf_token) do
    claims = %{
      "user_id" => user_id,
      "role" => role,
      "xsrf_token" => xsrf_token
    }

    token = Server.Token.generate_and_sign!(claims)
    token
  end

  def verify_token(token) do
    case Server.Token.verify_and_validate(token) do
      {:ok, claims} -> claims
      _ -> {:error, "Invalid token"}
    end
  end

  def decode_token(token) do
    case JOSE.JWT.verify(token, :HS256, "secret") do
      {:ok, claims} ->
        {:ok, Map.take(claims, ["user_id", "role", "xsrf_token"])}

      {:error, _reason} ->
        {:error, "Invalid token"}
    end
  end
end
