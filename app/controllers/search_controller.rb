class SearchController < ApplicationController
    def index
        
    end 
    
    def create
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
        filtered_items = json_data.select { |item|
            (if include_name.empty?
                true
            else #name include filter
                include_name.all? { |rule| item['Name'].split(", ").any? {|check| check.downcase == (rule.downcase)}}
            end &&
            if include_type.empty?
                true
            else #type include filter
                include_type.all? { |rule| item['Type'].split(", ").any? {|check| check.downcase == (rule.downcase)}}
            end &&
            if designed_by.empty?
                true
            else #designed by filter
                designed_by.all? { |rule| item['Designed by'].split(", ").any? {|check| check.downcase == (rule.downcase)}}
            end)&&(
                #exclude filter
                !exclude_name.any? { |rule| item['Name'].split(", ").any? {|check| check.downcase == (rule.downcase)}} &&
                !exclude_type.any? { |rule| item['Type'].split(", ").any? {|check| check.downcase == (rule.downcase)}} &&
                !not_designed_by.any? { |rule| item['Designed by'].split(", ").any? {|check| check.downcase == (rule.downcase)}}        
            ) 
        }
        return filtered_items
    end  

      
end
