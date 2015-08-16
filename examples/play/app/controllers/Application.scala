// Copyright 2015 basebuilder authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package controllers

import play.api.mvc._

object Application extends Controller {

  def index = Action {
    Ok("Hello world from tsuru")
  }

}
