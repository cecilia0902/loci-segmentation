# Copyright 2017 Xinyi Wang All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS-IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

v = VideoWriter('/Users/wangxinyi/Desktop/CTIA/project/data/root0/video root0.avi');
v.FrameRate = 1;
% Open the file for writing and write a 300-by-300 matrix of data to the
% file.
open(v)
%%writeVideo(v,rand(300))
path= '/Users/wangxinyi/Desktop/CTIA/project/data/root0/root0.';  
for i = 1:10
    frame = sprintf('%s%d',path,i,'.jpg');
    frame = strcat(frame);
    A = imread(frame);
    writeVideo(v,A);
end
close(v)
