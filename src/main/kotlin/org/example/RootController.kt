package org.example

import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class RootController {

    @RequestMapping("/")
    fun home() = "Hello World!"
}