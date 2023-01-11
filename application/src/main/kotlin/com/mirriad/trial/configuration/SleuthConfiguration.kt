package com.mirriad.trial.configuration

import brave.Tracer
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.web.server.ServerWebExchange
import org.springframework.web.server.WebFilter
import org.springframework.web.server.WebFilterChain
import reactor.core.publisher.Mono

@Component
class SleuthConfiguration : WebFilter {

    @Autowired
    lateinit var tracer: Tracer

    override fun filter(exchange: ServerWebExchange, chain: WebFilterChain): Mono<Void> {
        exchange.response.headers.add(REQUEST_ID_HEADER, tracer.currentSpan()?.context()?.traceId()?.toString()?: "")
        return chain.filter(exchange)
    }

}