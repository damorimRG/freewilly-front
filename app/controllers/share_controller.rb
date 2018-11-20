require 'net/ssh'
require 'aws-sdk-s3'

class ShareController < ApplicationController

    skip_before_action :verify_authenticity_token

    def index
        
    end

    def flask
        pwd = PwdInterface.new 'localhost'
        session = pwd.create_session
        instance = pwd.create_instance(session)

        s3 = Aws::S3::Resource.new(region: 'us-east-2', 
                           access_key_id: 'AKIAJVVVE2EANF34OBMQ', 
                           secret_access_key: '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')
        flaskZip = s3.bucket('docker-fiddle').object('shares/root.tar.gz').presigned_url(:get, expires_in: 60 * 60)
        puts flaskZip
        
        Net::SSH.start("direct.localhost", instance.proxy_host, port: 8022) do |ssh|
            ssh.exec!("cd / && curl \"#{flaskZip}\" -o root.tar.gz && tar xvf root.tar.gz -C /root && rm -rf root.tar.gz && mv /root/root/* /root && rm -rf /root/root")
            ssh.loop
            redirect_to "http://localhost/p/#{session}"
        end
    end

    def share
        pwd = PwdInterface.new 'localhost'
        session = params[:session]
        instances = pwd.get_instances(session)
        instances.each do |instance|
            Net::SSH.start("direct.localhost", instance['proxy_host'], port: 8022) do |ssh|
                
                ssh.exec! 'cd / && tar cvfz /root.tar.gz root/ --exclude ".*"'
                ssh.loop
                s3 = Aws::S3::Resource.new(region: 'us-east-2', 
                           access_key_id: 'AKIAJVVVE2EANF34OBMQ', 
                           secret_access_key: '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')
                url = s3.bucket('docker-fiddle').object('shares/root.tar.gz').presigned_url(:put)

                ssh.exec! "cd / && curl -X PUT \"#{url}\" -T /root.tar.gz && rm -rf /root.tar.gz"
                ssh.loop
            end
        end
        render json: {status: 'ok'}
    end

end
