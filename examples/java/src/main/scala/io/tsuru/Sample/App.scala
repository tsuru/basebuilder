package io.tsuru.Sample

import com.twitter.finatra._
import com.twitter.finatra.ContentType._

class HelloWorld extends Controller {
	get("/") { request =>
		render.plain("Hello world from tsuru").toFuture
	}
}

object App extends FinatraServer {
	register(new HelloWorld())
}
