module SearchFilter
  private
  def filter?(include_name,include_type,designed_by,exclude_name,exclude_type,not_designed_by,item)
    include_rules?(include_name,include_type,designed_by,item) && 
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
        include_parameter.all? do |rule| 
          item[parameter_name].split(", ").any? do |check|
            check.downcase.include?(rule.downcase)
          end
        end
    end  
  end      

  def exclude_rule?(exclude_parameter,parameter_name,item) 
    !exclude_parameter.any? do |rule| 
      item[parameter_name].split(", ").any? do |check| 
        check.downcase == (rule.downcase)
      end
    end  
  end
end