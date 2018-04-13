defmodule FTPoison.Base do
  alias FTPoison.Error

  defmacro __using__(_) do
    quote do
      @doc "Changes the working directory at the remote server to Dir."
      @spec cd(PID, String.t) :: String.t
      def cd(pid, directory) do
        case :ftp.cd(pid, to_charlist(directory)) do
          :ok -> pid
          e -> handle_error(e)
        end
      end

      @doc "Starts a standalone FTP client process (without the Inets service framework)
      and opens a session with the FTP server at Host."
      @spec open(String.t, map) :: {:ok, PID} | {:error, {atom, atom}}
      def open(host, options \\ %{}) do
      end

      @doc "Returns the current working directory at the remote server."
      @spec pwd(PID) :: String.t
      def pwd(pid) do
        case :ftp.pwd(pid) do
          {:ok, dir_char_list} -> to_string dir_char_list
          e -> handle_error(e)
        end
      end

      @doc "Returns a list of remote files in the current directory"
      @spec list(PID) :: String.t
      def list(pid) do
        case :ftp.nlist(pid) do
          {:ok, dir_listing} -> to_string(dir_listing) |> String.split("\r\n", trim: true)
          e -> handle_error(e)
        end
      end

      @doc "Returns a list of remote files matching the specified path (supporting globs)"
      @spec list(PID, String.t) :: String.t
      def list(pid, path) do
        case :ftp.nlist(pid, to_charlist(path)) do
          {:ok, dir_listing} -> to_string(dir_listing) |> String.split("\r\n", trim: true)
          e -> handle_error(e)
        end
      end

      @spec recv(PID, String.t) :: {:ok, PID}
      def recv(pid, remote_file) do
        case :ftp.recv(pid, to_charlist(remote_file)) do
          :ok -> pid
          e -> handle_error(e)
        end
      end

      @spec recv(PID, String.t, String.t) :: {:ok, PID}
      def recv(pid, remote_file, local_file) do
        case :ftp.recv(pid, to_charlist(remote_file), to_charlist(local_file)) do
          :ok -> pid
          e -> handle_error(e)
        end
      end

      @spec start(String.t) :: {:ok, PID} | {:error, {atom, atom}}
      def start(host) do
        start_inets()
        case :inets.start(:ftpc, host: to_charlist(host)) do
          {:ok, pid} -> pid
          e -> handle_error(e)
        end
      end

      @spec stop(PID) :: any
      def stop(pid) do
        :inets.stop(:ftpc, pid)
      end

      @spec user(PID, String.t, String.t) :: {:ok, PID}
      def user(pid, username, password) do
        case :ftp.user(pid, to_charlist(username), to_charlist(password)) do
          :ok -> pid
          e -> handle_error(e)
        end
      end

      @spec start_inets :: :ok
      defp start_inets do
        :inets.start
      end

      @spec to_charlist(String.t) :: List.t
      defp to_charlist(string) do
        string |> String.to_charlist
      end

      defp handle_error(error) do
        message = case error do
          {:error, reason} -> raise %Error{reason: reason}
          _ -> nil
        end
      end
    end
  end
end
