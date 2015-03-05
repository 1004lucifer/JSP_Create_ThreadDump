<%--
  Created by IntelliJ IDEA.
  User: 1004lucifer
  Date: 2015. 3. 5.
  Time: 오후 9:11
--%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<html>
<%!
    private String executeCommand(String command, String seperator) {
        StringBuffer result = new StringBuffer();
        String line = null;
        BufferedReader br = null;
        Process ps = null;
        try {
            Runtime rt = Runtime.getRuntime();
            ps = rt.exec(command);
            br = new BufferedReader(new InputStreamReader(new SequenceInputStream(ps.getInputStream(), ps.getErrorStream())));

            while( (line = br.readLine()) != null ) {
                result.append(line + seperator);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { br.close(); } catch(Exception e) {}
        }

        return result.toString();
    }

    private void saveLog(String file, String contents) {
        FileOutputStream fos = null;
        Date now = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String dt = sdf.format(now);
        try {
            fos = new FileOutputStream(file+"_"+dt.substring(0, 8)+".log", true);   // true:attach, false:overwrite
            for(int i=0; i<contents.length(); i++){
                fos.write(contents.charAt(i));
            }
            fos.write('\r');
            fos.write('\n');
        } catch (Exception e) {
            e.printStackTrace();
        } finally{
            if(fos != null){
                try{fos.close();
                }catch(IOException e){}
            }
        }
    }
%>
<body>
<%
    // Path where the pid.sh
    String commandGetPid = "/opt/tomcat/project_name/threadDump/pid.sh";
    // Path will be recorded ThreadDump
    String logPath = "/opt/tomcat/project_name/threadDump/threadDump_tservice_api";

    String commandThreadDump = "jstack ";   // Instruction for generating a ThreadDump


    String pid = null;
    String threadDump = null;

    try{
        pid = executeCommand(commandGetPid, "");
        threadDump = pid == null ? null : executeCommand(commandThreadDump + pid, "\n");

        if (threadDump != null) {
            saveLog(logPath, threadDump);
            out.println(threadDump.replaceAll("\n", "<br/>"));
        }
    }catch(Exception e){
        e.printStackTrace();
    }
%>
</body>
</html>