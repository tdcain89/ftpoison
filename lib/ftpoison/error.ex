defmodule FTPoison.Error do
  defexception reason: nil
  @type t :: %__MODULE__{reason: any}

  def message(%__MODULE__{reason: reason}), do: parse_error_reason(reason)

  def parse_error_reason(reason) when is_atom(reason), do: error_reason_map[reason]
  def parse_error_reason(reason), do: to_string(reason)

  defp error_reason_map do
    %{
      ehost: "Host is not found, FTP server is not found, or connection is rejected by FTP server.",
      eclosed: "The session is closed.",
      econn: "Connection to the remote server is prematurely closed.",
      elogin: "User is not logged in.",
      enotbinary: "Term is not a binary.",
      epath: "No such file or directory, or directory already exists, or permission denied.",
      etype: "No such type.",
      euser: "Invalid username or password.",
      etnospc: "Insufficient storage space in system [452].",
      epnospc: "Exceeded storage allocation (for current directory or dataset) [552].",
      efnamena: "Filename not allowed [553].",
      enofile: "No such file or directory.",
    }
  end
end
