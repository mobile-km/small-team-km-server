module ModelCallbackRuleMethods
 def self.included(base)
    base.after_create   :run_model_callback_after_create
    base.after_update   :run_model_callback_after_update
    base.after_destroy  :run_model_callback_after_destroy

    base.alias_method_chain :method_missing, :model_callback_rule
    base.alias_method_chain :respond_to?, :model_callback_rule
  end

  def run_model_callback_after_create
    run_model_callback_by_callback_type(:after_create)
  end

  def run_model_callback_after_update
    run_model_callback_by_callback_type(:after_update)
  end

  def run_model_callback_after_destroy
    run_model_callback_by_callback_type(:after_destroy)
  end

  def run_model_callback_by_callback_type(callback_type)
    ModelCallbackManagement.run_all_logic_by_rules(self, callback_type)
    return true
  end

  def respond_to_with_model_callback_rule?(method_id)
    if respond_to_without_model_callback_rule?(method_id)
      return true
    else
      return ModelCallbackManagement.has_method?(self,method_id.to_sym)
    end
  end

  def method_missing_with_model_callback_rule(method_id, *args)
    if ModelCallbackManagement.has_method?(self,method_id)
      return ModelCallbackManagement.do_method(self,method_id, *args)
    else
      return method_missing_without_model_callback_rule(method_id, *args)
    end
  end
end