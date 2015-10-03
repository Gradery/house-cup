# This is not a real controller for webpages.
# It is used to render HTML output for PDFKit.
# Use it like this:
# InvoicesController.new.show(&lt;invoice id&gt;)

class BackgroundViewController < AbstractController::Base
 include AbstractController::Rendering
 include AbstractController::Helpers
 include AbstractController::Translation
 include AbstractController::AssetPaths  
 self.view_paths = "app/views"

 def show(view_name)
   render layout: "api", template: view_name
 end 

end