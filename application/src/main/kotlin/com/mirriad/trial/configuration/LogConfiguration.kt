package com.mirriad.trial.configuration


import org.aspectj.lang.annotation.Aspect
import org.aspectj.lang.annotation.Pointcut
import org.springframework.aop.Advisor
import org.springframework.aop.aspectj.AspectJExpressionPointcut
import org.springframework.aop.interceptor.PerformanceMonitorInterceptor
import org.springframework.aop.support.DefaultPointcutAdvisor
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.EnableAspectJAutoProxy
import org.springframework.web.filter.CommonsRequestLoggingFilter

@EnableAspectJAutoProxy
@Aspect
@Configuration
class LogConfiguration {

    @Pointcut(
            "within(com.mirriad..*)"
    )
    fun performanceLog() {
    }

    @Bean
    fun performanceMonitorInterceptor(): PerformanceMonitorInterceptor {
        return PerformanceMonitorInterceptor(true)
    }

    @Bean
    fun performanceMonitorAdvisor(): Advisor {
        val pointcut = AspectJExpressionPointcut()
        pointcut.setExpression(this.javaClass.name + ".performanceLog()")
        return DefaultPointcutAdvisor(pointcut, performanceMonitorInterceptor())
    }

}