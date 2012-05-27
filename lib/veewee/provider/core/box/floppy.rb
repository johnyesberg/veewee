module Veewee
  module Provider
    module Core
      module BoxCommand
        def cygpath(s)
          `/bin/cygpath -w #{s}`.chomp
        end

	def escape(s)
          s.gsub('\\','\\\\\\\\')
        end

        def create_floppy(filename)
          # Todo Check for java
          # Todo check output of commands

          # Check for floppy
          unless definition.floppy_files.nil?
            require 'tmpdir'
            temp_dir=Dir.mktmpdir
            definition.floppy_files.each do |filename|
              full_filename=full_filename=File.join(definition.path,filename)
              FileUtils.cp("#{full_filename}","#{temp_dir}")
            end
            javacode_dir=File.expand_path(File.join(__FILE__,'..','..','..','..','..','java'))
            floppy_file=File.join(definition.path,filename)
            if File.exists?(floppy_file)
              env.logger.info "Removing previous floppy file"
              FileUtils.rm(floppy_file)
            end
            jar_file=File.join(javacode_dir,"dir2floppy.jar")
            command="java -jar #{escape(cygpath(jar_file))} \"#{escape(cygpath(temp_dir))}\" \"#{escape(cygpath(floppy_file))}\""
            ui.info("Creating floppy: #{command}")
            shell_exec("#{command}")
          end
        end

      end
    end
  end
end
