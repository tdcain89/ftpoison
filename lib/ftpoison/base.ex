defmodule FTPoison.Base do
  defmacro __using__(_) do
    quote do
      @doc "Changes the working directory at the remote server to Dir."
      @spec cd(PID, String.t) :: :ok | {:error, {atom, atom}}
      def cd(pid, directory) do
        case :ftp.cd(pid, to_charlist(directory)) do
          :ok -> :ok
          e -> handle_error(e)
        end
      end

      @doc "Starts a standalone FTP client process (without the Inets service framework)
      and opens a session with the FTP server at Host."
      @spec open(String.t, map) :: :ok
      def open(host, options \\ %{}) do
        :ok
      end

      @doc "Returns the current working directory at the remote server."
      @spec pwd(PID) :: {:ok, String.t} | {:error, {atom, atom}}
      def pwd(pid) do
        case :ftp.pwd(pid) do
          {:ok, dir_char_list} -> {:ok, to_string(dir_char_list)}
          e -> handle_error(e)
        end
      end

      @doc "Returns a list of remote files in the current directory"
      @spec list(PID) :: { :ok, [String.t]} | {:error, {atom, atom}}
      def list(pid) do
        case :ftp.nlist(pid) do
          {:ok, dir_listing} -> {:ok, to_string(dir_listing) |> String.split("\r\n", trim: true)}
          e -> handle_error(e)
        end
      end

      @doc "Returns a list of remote files matching the specified path (supporting globs)"
      @spec list(PID, String.t) :: {:ok, [String.t]} | {:error, {atom, atom}}
      def list(pid, path) do
        case :ftp.nlist(pid, to_charlist(path)) do
          {:ok, dir_listing} -> {:ok, to_string(dir_listing) |> String.split("\r\n", trim: true)}
          e -> handle_error(e)
        end
      end

      @spec recv(PID, String.t) :: :ok | {:error, {atom, atom}}
      def recv(pid, remote_file) do
        case :ftp.recv(pid, to_charlist(remote_file)) do
          :ok -> :ok
          e -> handle_error(e)
        end
      end

      @spec recv(PID, String.t, String.t) :: :ok | {:error, {atom, atom}}
      def recv(pid, remote_file, local_file) do
        case :ftp.recv(pid, to_charlist(remote_file), to_charlist(local_file)) do
          :ok -> :ok
          e -> handle_error(e)
        end
      end

      @spec recv_bin(PID, binary()) :: {:ok, binary()} | {:error, {atom, atom}}
      def recv_bin(pid, remote_file) do
        case :ftp.recv_bin(pid, to_charlist(remote_file)) do
          {:ok, contents} -> {:ok, contents}
          e -> handle_error(e)
        end
      end

      @spec send(PID, String.t) :: :ok | {:error, {atom, atom}}
      def send(pid, local_file) do
        case :ftp.send(pid, to_charlist(local_file)) do
          :ok -> :ok
          e -> handle_error(e)
        end
      end

      @spec send(PID, String.t, String.t) :: :ok | {:error, {atom, atom}}
      def send(pid, local_file, remote_file) do
        case :ftp.send(pid, to_charlist(local_file), to_charlist(remote_file)) do
          :ok -> :ok
          e -> handle_error(e)
        end
      end

      @spec send_bin(PID, String.t, String.t) :: :ok | {:error, {atom, atom}}
      def send_bin(pid, contents, remote_file) do
        case :ftp.send_bin(pid, contents, to_charlist(remote_file)) do
          :ok -> :ok
          e -> handle_error(e)
        end
      end

      @spec delete(PID, String.t) :: :ok | {:error, {atom, atom}}
      def delete(pid, remote_file) do
        case :ftp.delete(pid, to_charlist(remote_file)) do
          :ok -> :ok
          e -> handle_error(e)
        end
      end

      @spec start(String.t) :: {:ok, PID} | {:error, {atom, atom}}
      def start(host) do
        start_inets()
        case :inets.start(:ftpc, host: to_charlist(host)) do
          {:ok, pid} -> {:ok, pid}
          e -> handle_error(e)
        end
      end

      @spec stop(PID) :: any
      def stop(pid) do
        :inets.stop(:ftpc, pid)
      end

      @spec user(PID, String.t, String.t) :: :ok | {:error, {atom, atom}}
      def user(pid, username, password) do
        case :ftp.user(pid, to_charlist(username), to_charlist(password)) do
          :ok -> :ok
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
        error
      end
    end
  end
end
