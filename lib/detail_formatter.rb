class DetailFormatter < ::Logger::Formatter
  SEVERITY_TO_COLOR_MAP = { 'DEBUG' => '0;37', 'INFO' => '32', 'WARN' => '33', 'ERROR' => '31', 'FATAL' => '31' }.freeze

  attr_accessor :color

  def initialize(options = {})
    @color = options[:color] || false
  end

  def call(severity, datetime, _progname, msg)
    formatted_time = datetime.iso8601
    formatted_time = "\033[0;37m#{formatted_time}\033[0m" if color

    formatted_severity = format('%5s', severity)
    if color
      color = SEVERITY_TO_COLOR_MAP[severity] || '37'
      formatted_severity = "\033[#{color}m#{formatted_severity}\033[0m"
    end

    msg += "\n" if msg[-1] != "\n"

    "#{formatted_time} [#{formatted_severity}] #{Process.pid} : #{msg}"
  end
end
