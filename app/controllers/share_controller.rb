require 'net/ssh'
require 'aws-sdk-s3'

class ShareController < ApplicationController

    skip_before_action :verify_authenticity_token

    def index
        
    end

    def faq

    end

    def tutorial

    end

    def not_found
        render :json => {status: 'not found', error: 404}
    end

    def create
        pwd = PwdInterface.new 'localhost'
        pwdSession = pwd.create_session
        redirect_to "http://localhost/p/#{pwdSession}"
    end

    def shared
        s3 = Aws::S3::Resource.new(region: 'us-east-2', 
                           access_key_id: 'AKIAJVVVE2EANF34OBMQ', 
                           secret_access_key: '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')

        session = Session.includes(:instances).find_by_uuid(params[:session])
        if not session
            return not_found
        end
        pwd = PwdInterface.new 'localhost'
        pwdSession = pwd.create_session
        
        session.instances.each do |instance|
            pwdInstance = pwd.create_instance(pwdSession)

            downloadLink = s3.bucket('docker-fiddle').object("shares/#{session.uuid}/#{instance.uuid}.tar.gz").presigned_url(:get, expires_in: 60 * 60)
            puts downloadLink
            Net::SSH.start("direct.localhost", pwdInstance.proxy_host, port: 8022) do |ssh|
                ssh.exec!("cd / && curl \"#{downloadLink}\" -o root.tar.gz && tar xvf root.tar.gz -C /root && rm -rf root.tar.gz && mv /root/root/* /root && rm -rf /root/root")
                ssh.loop
            end
        end

        redirect_to "http://localhost/p/#{pwdSession}"
    end

    def share
        pwd = PwdInterface.new 'localhost'
        pwdSession = params[:session]
        pwdInstances = pwd.get_instances(pwdSession)

        s3 = Aws::S3::Resource.new(region: 'us-east-2', 
                           access_key_id: 'AKIAJVVVE2EANF34OBMQ', 
                           secret_access_key: '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')

        session = Session.create(uuid: SecureRandom.uuid)
        pwdInstances.each do |pwdInstance|

            instance = Instance.create(uuid: SecureRandom.uuid, session_id: session.id)
            Net::SSH.start("direct.localhost", pwdInstance['proxy_host'], port: 8022) do |ssh|
                
                ssh.exec! 'cd / && tar cvfz /root.tar.gz root/ --exclude ".*"'
                ssh.loop
                url = s3.bucket('docker-fiddle').object("shares/#{session.uuid}/#{instance.uuid}.tar.gz").presigned_url(:put)
                ssh.exec! "cd / && curl -X PUT \"#{url}\" -T /root.tar.gz && rm -rf /root.tar.gz"
                ssh.loop
            end
        end
        render json: {status: 'ok', uuid: session.uuid}
    end

end
