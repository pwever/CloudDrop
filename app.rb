require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/base'
require 'date'
require 'ftools'
require 'fileutils'
require 'digest/sha1'
require 'zipruby'






class MyApp < Sinatra::Base
  set :static, true
  set :public, File.dirname(__FILE__) + '/public'

  # Default action is to allow the user to upload a new file
  get '/' do
    erb :index
  end


  # Manually delete old files
  get '/clean' do
    n = delete_old_files
    erb :index, :locals => { :note => "Deleted #{n} old files." }
  end


  # Any file posted to the root is zipped and stored
  post '/' do
    puts params


    unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
      @error = "No file selected"
      return @error
    end
    
    tmpfile  = params[:file][:tempfile].path
    filename = params[:file][:filename]
    hashname = Digest::SHA1.hexdigest(filename + Time.now.to_s)
    zippath  = File.join(".", "drops", "%s.zip" % hashname)
    
    if (params[:zippwd] && !params[:zippwd].empty?) then
      # create a encrypted zip archive
      tmpzip = File.join("/tmp", "%s.zip" % filename)
      Zip::Archive.open(tmpzip, Zip::CREATE) do |ar|
        open(tmpfile) do |f|
          ar.add_buffer(filename, f.read)
        end
        ar.encrypt params[:zippwd]
      end
      File.delete(tmpfile)
      tmpfile = tmpzip
      filename += ".zip"
    end
    
    # zip it all up (again) to keep the file system clean
    Zip::Archive.open(zippath, Zip::CREATE) do |ar|
      open(tmpfile) do |f|
        ar.add_buffer(filename, f.read)
      end
    end
    File.delete(tmpfile)
    
    if (params[:ajax]) then
      Zip::Archive.open(zippath) do |ar|
        d = Date.parse(File.mtime(zippath).to_s) + 14
        erb :post, :layout => false, :locals => {:uri => url("/%s" % hashname), :filename => ar.get_name(0), :filesize => ar.get_stat(0).size.to_human, :expires_on => d.to_s}
      end
    else
      redirect "/view/%s" % hashname
    end
    
  end


  # this shows the link to the file
  get '/view/:needle' do |needle|
    puts "/view/:needle received this request: %s" % request


    fileuri = url( "/%s" % needle )
    archive_path = File.join('.', 'drops', '%s.zip' % needle)
    
    if (File.exists? archive_path) then
      Zip::Archive.open(archive_path) do |ar|
        d = Date.parse(File.mtime(archive_path).to_s) + 14
        erb :post, :locals => {:uri => fileuri, :filename => ar.get_name(0), :filesize => ar.get_stat(0).size.to_human, :expires_on => d.to_s}
      end
    else 
      erb :index, :locals => { :note => "File not found." }
    end
  end


  # this serves the actual file
  get '/:needle' do |needle|

    # NOTE: This should really happen on a cron job
    delete_old_files

    srcpath = File.join(".", "drops", "%s.zip" % needle)
    # Check if file exists
    if (File.exists? srcpath) then
    
      Zip::Archive.open(srcpath) do |ar|
        attachment ar.get_name(0)

        ar.fopen(ar.get_name(0)) do |af|
          af.read
        end
      end

    else
      erb :index, :locals => { :note => "File not found." }
    end

  end







  def delete_old_files
    Dir.chdir File.dirname(__FILE__)
    two_weeks_ago = DateTime.now - 14
    n = 0
    Dir.glob("drops/*.zip").each do |f|
      if (DateTime.parse(File.mtime(f).to_s)<two_weeks_ago) then
        File.delete(f)
        n += 1
      end
    end
    n
  end

end

class Numeric
  def to_human
    units = %w{B KB MB GB TB}
    e = (Math.log(self)/Math.log(1024)).floor
    s = "%.1f" % (to_f / 1024**e)
    s.sub(/\.?0*$/, units[e])
  end
end

MyApp.run!








