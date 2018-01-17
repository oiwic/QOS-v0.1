function infoDisp()
    jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
    jCmdWin = jDesktop.getClient('Command Window');
    jTextArea = jCmdWin.getComponent(0).getViewport.getView;

    hf = qes.ui.qosFigure('Q Cloud', false);
    textBox = uicontrol('Stytle','text','String','','Position',[0,0,1,1]);
    
    set(jTextArea,'CaretUpdateCallback',@updateFcn);
    
    function updateFcn(s,e)
        persistent cwText;
        persistent numLines;
        if isempty(numLines)
            numLines = 0;
        end
        cwText = [cwText,13,10,char(jTextArea.getText)];
        set(textBox,'String',cwText);
        numLines = numLines + 1;
        if numLines > 20
            cwText = [];
            numLines = 0; 
        end
    end
end