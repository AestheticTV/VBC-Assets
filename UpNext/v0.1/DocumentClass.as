package {
	
	import flash.accessibility.*;
	import flash.events.*
	import flash.net.*
	import se.svt.caspar.template.CasparTemplate;

	public class DocumentClass extends CasparTemplate {
		
		private var loader : URLLoader;

		public function DocumentClass() {
			super();
			// constructor code
			this.loader = new URLLoader();
			this.configureListeners(loader);

			var request: URLRequest = new URLRequest("http://5e6a2db70f70dd001643bb30.mockapi.io/api/v1/upnext");
			
			try {
				this.debug("Loading...");
				loader.load(request);
			} catch (error: Error) {
				this.debug("Unable to load requested document.");
			}
			
		}
		
		private function configureListeners(dispatcher: IEventDispatcher): void {
			dispatcher.addEventListener(Event.COMPLETE, onComplete);
			dispatcher.addEventListener(Event.OPEN, onOpen);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, onProgress);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}

		private function onComplete(event: Event): void {
			var loader: URLLoader = URLLoader(event.target);
			this.debug("onComplete: " + loader.data);
		}

		private function onOpen(event: Event): void {
			this.debug("onOpen: " + event);
		}

		private function onProgress(event: ProgressEvent): void {
			this.debug("onProgress loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}

		private function onSecurityError(event: SecurityErrorEvent): void {
			this.debug("onSecurityError: " + event);
		}

		private function onHTTPStatus(event: HTTPStatusEvent): void {
			this.debug("onHTTPStatus: " + event);
		}

		private function onIOError(event: IOErrorEvent): void {
			this.debug("onIOError: " + event);
		}
		
		private function debug(input: String): void {
			trace("[DocumentClass] " + input);
		}

	}

}