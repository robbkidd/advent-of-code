class UglySweater
  String.prepend(
    Module.new do
      def make_it_red
        "\e[41m#{self.delete_suffix("\e[0m")}\e[0m"
      end
      def make_it_green
        "\e[32m#{self.delete_suffix("\e[0m")}\e[0m"
      end
      def make_it_bold
        "\e[1m#{self.delete_suffix("\e[0m")}\e[0m"
      end
    end
  )
  # for use with outputs that are periods and octothorps
  def self.ugly_christmas_sweater(output = "")
    output.gsub(/#/, make_it_red("#")).gsub(/\./, make_it_green("."))
  end

  def ugly_christmas_sweater(output)
    self.class.ugly_christmas_sweater(output)
  end

  def self.make_it_red(s, bold: false)
    "\e[41m\e[1m#{s}\e[0m"
  end

  def self.make_it_green(s)
    "\e[32m#{s}\e[0m"
  end

  def self.clear_codes
    "\e[H\e[2J"
  end

  def clear_codes
    self.class.clear_codes
  end
end
