##
# http://www.perfectline.co/blog/2011/11/adding-flash-message-capability-to-your-render-calls-in-rails-3/ Genius!
#

module ActionController
  module Flash

    def render(*args)
      options = args.last.is_a?(Hash) ? args.last : {}

      if alert = options.delete(:alert)
        flash[:alert] = alert
      end

      if notice = options.delete(:notice)
        flash[:notice] = notice
      end

      if other = options.delete(:flash)
        flash.update(other)
      end

      super(*args)
    end

  end
end