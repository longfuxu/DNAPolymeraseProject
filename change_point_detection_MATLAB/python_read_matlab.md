In order to call matlab script from python, you need to use the MATLAB Engine API [https://nl.mathworks.com/help/matlab/matlab-engine-for-python.html?s_tid=CRUX_lftnav]

Step#1: Install the MATLAB Engine API [https://nl.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html]
- one note for this step: you might need administrator privileges to execute these commands

Step#2: read the matlab script from python
import matlab.engine
eng = matlab.engine.start_matlab()
eng.yourmatlab_script(nargout=0)
- one note for this step:# you must add nargout=0 to run .m script, otherwise it will run as a function, see [https://nl.mathworks.com/matlabcentral/answers/816065-execution-of-script-vgg16-as-a-function-is-not-supported]

Step#3: you might want to edit some parameters in the script
eng.edit('yourmatlab_script',nargout=0)

Step#4: in case you want to call a function written in matlab, you can use:[https://nl.mathworks.com/help/matlab/matlab_external/call-matlab-functions-from-python.html]
import matlab.engine
eng = matlab.engine.start_matlab()
t = eng.gcd(100.0,80.0,nargout=3)
print(t)