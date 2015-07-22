require 'zendesk_api'
require 'net/http'
require 'commander/import'
require 'highline/import'

program :version, '2.0'
program :description, 'This script allows you deleting Zendesk organizations that contain specific tag'
program :help, 'Author', 'Andrey Sarapulov <asarapulov@zendesk.com>'
default_command :run

command :run do |c|
  c.description = 'just run :)'
  c.action do |args, options|

    say "\n"
    say "----------------------------------------------------------------"
    say "               Script configuration"
    say "----------------------------------------------------------------"
    say "\n"
    say "Please enter your account details below:                        "
    say "\n\n"
    
    url       = ask "Subdomain: (e.g mycompany.zendesk.com): "
    email     = ask "Email (e.g admin@company.com): "
    api_token = ask ("API Token (will not be displayed): ") { |q| q.echo = "*" }
    
    say "\n\n"
    say "Enter organization tag:                                         "
    say "\n\n"
    
    org_tag       = ask "Tag: (e.g test): "

    @client = ZendeskAPI::Client.new do |config|

      config.url = "https://#{url}/api/v2"
      config.username = email
      config.token = api_token
      config.retry = true

    end

    say "----------------------------------------------------------------"
    say "              Running script..."
    say "----------------------------------------------------------------"

          def processingSearch(orgs) # SHOW SEARCH RESULTS AND ASK FOR CONFIRMATION
                
                isConfirmed = false
                say "Running a search..."
                orgs.all do |resource|
                
                      begin
                            org_name = resource.name
                            org_id =  resource.id  
                            puts "#{org_name} [#{org_id}]"
                      end
                end
                      if isConfirmed == false
                            exit unless HighLine.agree('Do you want to proceed with removal of organizations listed above? (y/n)')
                            isConfirmed = true
                            deletingOrgs(orgs)
                      end
          end

          def deletingOrgs(orgs) # DELETE ORGS FROM SEARCH RESULTS
                  
                  total = 0
                  say "Deleting organizations..."
                    
                    File.open("deleted_organizations.txt", "w") do |f|     
                        orgs.all do |resource|
                            begin
                              org_name = resource.name
                              org_id =  resource.id
                              total += 1

                              puts "Deleting #{org_name} [#{org_id}]..."
                              @client.connection.delete("organizations/#{org_id}.json")
                              f.write("#{org_name} [#{org_id}]\n")   

                                begin
                                  rescue ZendeskAPI::Error::NetworkError => e # ALSO LOG ERRORS INTO A FILE
                                    net_error = e.inspect
                                    puts net_error
                                    f.write("Network Error: #{net_error}")
                                    retry
                                  rescue ZendeskAPI::Error::ClientError => e
                                    client_error = e.inspect
                                    puts client_error
                                    f.write("Client Error: #{client_error}")
                                  rescue Exception => e
                                    uknown_error = e.inspect
                                    puts uknown_error
                                    f.write("Uknown Error: #{uknown_error}")
                                end
                            end
                        end
                    end

                    puts "\nDone! #{total} organization(s) deleted."
          end

      begin # RUNNING SEARCH QUERY HERE
        orgs = @client.search(:query => "type:organization tags:#{org_tag}") # /api/v2/search.json?query=type:organization tags:dublin     
        if orgs.length == 0
          puts "Your search returns zero results please double check yor account details and/or organization tag"
        else
          processingSearch(orgs) # PROCESSING SEARCH RESULTS
      end
    end
  end
end
