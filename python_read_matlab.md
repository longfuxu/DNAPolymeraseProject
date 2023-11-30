In order to call a MATLAB script from Python, you need to use the MATLAB Engine API for Python. [MATLAB Engine API for Python](https://nl.mathworks.com/help/matlab/matlab-engine-for-python.html?s_tid=CRUX_lftnav)

Step 1: Install the MATLAB Engine API for Python. [Install the MATLAB Engine API for Python](https://nl.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html)
**Note:** You might need administrator privileges to execute these commands.

Step 2: Read the MATLAB script from Python.
import matlab.engine
eng = matlab.engine.start_matlab()
eng.yourmatlab_script(nargout=0)
**Note:** You must add `nargout=0` to run the `.m` script; otherwise, it will run as a function. See [Execution of script as a function is not supported](https://nl.mathworks.com/matlabcentral/answers/816065-execution-of-script-vgg16-as-a-function-is-not-supported).

Step 3: Edit parameters in the MATLAB script from Python, if necessary.
eng.edit('yourmatlab_script',nargout=0)

Step 4: To call a function written in MATLAB from Python, you can use the following method. [Call MATLAB Functions from Python](https://nl.mathworks.com/help/matlab/matlab_external/call-matlab-functions-from-python.html)
import matlab.engine
eng = matlab.engine.start_matlab()
t = eng.gcd(100.0,80.0,nargout=3)
print(t)
