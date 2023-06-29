require "annotate_gem/options"

module AnnotateGem
  class CLI
    def run(args)
      options = Options.new.parse!(args)
      if args.empty?
        run_for_gemfile(options)
      else
        run_for_gem(args.pop, options)
      end
    end

    def run_for_gemfile(options = {})
      Bundler.configure
      gemfile = Gemfile.new(Bundler.default_gemfile, options)
      gemfile.parse

      unless gemfile.gem_lines.empty?
        gemfile.write_comments
      end
    end

    def run_for_gem(gem_name, options = {})
      gem_line = GemLine.new(name: gem_name, options: options)

      info = gem_line.info
      info = "No information to show" if info.strip.empty?
      puts info
    end
  end
end
