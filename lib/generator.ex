defmodule Generator do


# Funkcja główna projektu

def main(argv) do

	argv
	|> parse_argv()
	|> generate_password()
end

# Parsowanie parametrów wejściowych

	def parse_argv(argv) do
		{options, _args, _invalid} = OptionParser.parse(argv, 
	switches:
	  	[ 
	  	type: :string,
		minlength: :integer,
		maxlength: :integer,
		uppercase: :boolean,
		numbers: :boolean,
		symbols: :boolean,
		separator: :string,
		file: :string
		])

	if(options[:type], do: {:ok, options}, else: IO.puts("Some error"))

	options

	end 


# Wybór generatora słowa/znaki


	def generate_password(options) do
		case options[:type] do
			"chars" -> generate_chars(options)
			"words" -> generate_words(options)
			_ -> generate_chars(options)
		end
	end


# Generator znaków


	defp generate_chars(options) do
		min_len = Keyword.get(options, :minlength, 8)
		max_len = Keyword.get(options, :maxlength, 16)
		rand_len =:rand.uniform(max_len - min_len + 1) + min_len - 1

		charset = build_charset(options)
		password = Enum.map(1..rand_len, fn x -> Enum.random(charset)end)
		IO.puts("Wygenerowane hasło:  #{password}")

		file_input(options[:file], password)
	end


# Generator znaków - parametry (wersaliki, liczby, symbole)


	defp build_charset(options) do
		charset = Enum.concat([
			Enum.to_list(?a..?z),
		if(options[:uppercase], do: Enum.to_list(?A..?Z), else: []),
		if(options[:numbers], do: Enum.to_list(?0..?9), else: []),
		if(options[:symbols], do: String.to_charlist("!@#$%^&*()-_=+[]{}|;:'\",.<>?/"), else: [])
		])
		charset
	end

# Generator słów


	defp generate_words(options) do
		min_len = Keyword.get(options, :minlength, 8)
		max_len = Keyword.get(options, :maxlength, 16)
		rand_len = :rand.uniform(max_len - min_len + 1) + min_len - 1
		separator = Keyword.get(options, :separator, "-") 

		words = ["hello", "world", "elixir", "generator", "password", "secure", "random", "example",
		"tip","top","hit","push","pull","try","set","get","count","give","let","say","end","one","last","life"]

		password = Enum.take_random(words, rand_len)
		pass = Enum.join(password, separator)
	  	IO.inspect("Wygenerowane hasło:  #{pass}")

	  	file_input(options[:file], pass)

	end

# Zapis hasła w pliku


	def file_input(nazwa, pass) do
		
	  if (nazwa != nil) do
	  case File.write(nazwa, pass) do
	  :ok -> IO.puts("Zapisano do pliku.")
	  {:error, reason} -> IO.puts("Wystąpił błąd podczas zapisu: #{reason}")
		end
	end
	end

end