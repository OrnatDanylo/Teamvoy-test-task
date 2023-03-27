class SearchController < ApplicationController
    def index
        
    end 
    
    def new
        if params[:message].present?
          message = params[:message]
          edited_message = find_message(message)
          render json: { message: edited_message }
        else
          render json: { error: "Message parameter missing" }, status: :unprocessable_entity
        end
    end

    private 

    def find_message(rules)
        data_file_path = Rails.root.join('public', 'data.json')
        json_data = JSON.parse(File.read(data_file_path).encode('UTF-8', 'Windows-1251'))
        #Get rules
        include_name = rules['input_include_name'].split(", ")
        exclude_name = rules['input_exclude_name'].split(", ")
        include_type = rules['input_include_type'].split(", ")
        exclude_type = rules['input_exclude_type'].split(", ")
        designed_by = rules['input_designed_by'].split(", ")
        not_designed_by = rules['input_not_designed_by'].split(", ")
        #filter
        filtered_items = $json_data.select do |item|
            filter?(include_name,include_type,designed_by,exclude_name,exclude_type,not_designed_by,item)
        end

        filtered_items
    end  

end
