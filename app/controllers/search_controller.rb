class SearchController < ApplicationController
    def index
        json_data_read
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

    def json_data_read 
        data_file_path = Rails.root.join('public', 'data.json')
        $json_data = JSON.parse(File.read(data_file_path).encode('UTF-8', 'Windows-1251'))
    end       

    def find_message(rules)
        #Get rules
        include_name = rules['input_include_name'].split(", ")
        exclude_name = rules['input_exclude_name'].split(", ")
        include_type = rules['input_include_type'].split(", ")
        exclude_type = rules['input_exclude_type'].split(", ")
        designed_by = rules['input_designed_by'].split(", ")
        not_designed_by = rules['input_not_designed_by'].split(", ")
        
        #filter
        filtered_items = $json_data.select do |item|
            filter?(include_name,exclude_name,designed_by,exclude_name,exclude_type,not_designed_by,item)
        end

        return filtered_items
    end  

    def filter?(include_name,exclude_name,designed_by,exclude_name,exclude_type,not_designed_by,item)
        include_rules?(include_name,exclude_name,designed_by,item) && 
        exclude_rules?(exclude_name,exclude_type,not_designed_by,item)
    end

    def include_rules?(name,type,designed_by,item)
        include_rule?(name,'Name',item) && 
        include_rule?(type,'Type',item) && 
        include_rule?(designed_by,'Designed by',item)
    end

    def exclude_rules?(name,type,designed_by,item)
        exclude_rule?(name,'Name',item) && 
        exclude_rule?(type,'Type',item) && 
        exclude_rule?(designed_by,'Designed by',item)
    end

    def include_rule?(include_parameter,parameter_name,item) 
        if include_parameter.empty?
            true
        else #include filter
            include_parameter.all? { |rule| item[parameter_name].split(", ").any? {|check| check.downcase == (rule.downcase)}}
        end  
    end      

    def exclude_rule?(exclude_parameter,parameter_name,item) 
        !exclude_parameter.any? { |rule| item[parameter_name].split(", ").any? {|check| check.downcase == (rule.downcase)}}
    end   
end
