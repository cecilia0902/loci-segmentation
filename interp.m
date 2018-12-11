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


obj=Tiff('/Users/wangxinyi/Desktop/CTIA/project/data/CLC-GFP A19 0.5MS root1.tif','r');
path='/Users/wangxinyi/Desktop/CTIA/project/data/root1_interp1.tif';
%name  = sprintf('%s%d',path,,'.tif');
for j=1:1
    

    setDirectory(obj,j);
    im1=read(obj);
    im1=im2double(im1);
    im2=interp2(im1,3);
    if j==1
        imwrite(im2,path);
    else
        imwrite(im2,path,'WriteMode','Append');
    end

end
