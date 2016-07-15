defmodule FTPoison.Base do
  alias FTPoison.Error

  defmacro __using__(_) do
    quote do
      @doc "Changes the working directory at the remote server to Dir."
      @spec cd(PID, String.t) :: String.t
      def cd(pid, directory) do
        case :ftp.cd(pid, to_char_list(directory)) do
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
      
      @spec recv(PID, String.t) :: {:ok, PID}
      def recv(pid, remote_file) do
        case :ftp.recv(pid, to_char_list(remote_file)) do
          :ok -> pid
          e -> handle_error(e)
        end
      end
      
      @spec recv(PID, String.t, String.t) :: {:ok, PID}
      def recv(pid, remote_file, local_file) do
        case :ftp.recv(pid, to_char_list(remote_file), to_char_list(local_file)) do
          :ok -> pid
          e -> handle_error(e)
        end
      end
      
      @spec start(String.t) :: {:ok, PID} | {:error, {atom, atom}}
      def start(host) do
        start_inets
        case :inets.start(:ftpc, host: to_char_list(host)) do
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
        case :ftp.user(pid, to_char_list(username), to_char_list(password)) do
          :ok -> pid
          e -> handle_error(e)
        end
      end
      
      @spec start_inets :: :ok
      defp start_inets do
        :inets.start
      end
      
      @spec to_char_list(String.t) :: List.t
      defp to_char_list(string) do
        string |> String.to_char_list 
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
