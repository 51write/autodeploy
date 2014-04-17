#!/usr/bin/env ruby
PROJECT_HOME = "/home/liusong/cqjw.mobile"
MAVEN_HOME = "/home/liusong/apache-maven-3.2.1/bin"
TOMCAT_HOME = "/usr/local/apache-tomcat-7.0.52/"

#获取项目


#编译项目
#mvn_msg = `cd #{PROJECT_HOME};#{MAVEN_HOME}/mvn clean install -Dmaven.test.skip=true -q`
#if mvn_msg != nil 
#    puts "项目编译错误..."
#end

puts '开始打包...'

puts "install依赖的子项目<model>...\n"
#打包依赖的项目
mytask = Thread.new { Thread.current["mvn_msg"] = `cd #{PROJECT_HOME}/model;#{MAVEN_HOME}/mvn clean install -Dmaven.test.skip=true -q`;sleep 0.1 }
#打印进度条
print = Thread.new do
        (1..100).each do |x|
                if mytask.alive?
                        printf "\r%s", x.to_s+'%'+'='*x+'>'
                        sleep 3
                else
                        printf "\r%s\n",'打包model完成100%,执行结果为:' + mytask["mvn_msg"];
                        break;
                end
        end
end  
mytask.join
print.join(300)

puts "install依赖的子项目<broadcast>...\n"
#打包依赖的项目2
mytask = Thread.new { Thread.current["mvn_msg"] = `cd #{PROJECT_HOME}/broadcast;#{MAVEN_HOME}/mvn clean install -Dmaven.test.skip=true -q`;sleep 0.1 }
#打印进度条
print = Thread.new do
        (1..100).each do |x|
                if mytask.alive?
                        printf "\r%s", x.to_s+'%'+'='*x+'>'
                        sleep 3
                else
                        printf "\r%s\n",'打包broadcast完成100%,执行结果为:' + mytask["mvn_msg"];
                        break;
                end
        end
end
mytask.join
print.join(300)

puts "打包项目\n"

#打包项目
mytask = Thread.new { Thread.current["mvn_msg"] = `cd #{PROJECT_HOME}/api;#{MAVEN_HOME}/mvn clean install -Dmaven.test.skip=true -q`;sleep 0.1 }

#打印进度条
print = Thread.new do
	(1..100).each do |x|
		if mytask.alive?
			printf "\r%s", x.to_s+'%'+'='*x+'>'
			sleep 3
		else
			printf "\r%s\n",'打包完成100%,执行结果为:' + mytask["mvn_msg"];
                        break;
		end
	end
end 
mytask.join
print.join(600)

pid = `netstat -anp | grep 8080 | awk '{print $7}' | awk -F"/" '{print $1}'`
if pid != nil && pid  != '-'
	msg = `kill #{pid}`
	msg = `rm -r  #{TOMCAT_HOME}/webapps/cqjw*`	
	msg = `mv #{PROJECT_HOME}/api/target/cqjw.war #{TOMCAT_HOME}/webapps/`
	msg = `#{TOMCAT_HOME}/bin/startup.sh`
end
