package domain;

/**
 * Copyright (c) 2017 onward, Yulin Wu. All rights reserved.
 * <p>
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * This software is provided on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND.
 * <p>
 * mail4ywu@gmail.com/mail4ywu@icloud.com
 * University of Science and Technology of China.
 */
/*
* 运行结果
 */
public class QuantumResult {
    private long taskId;
    // 实际运行的线路
    // 用户提供的线路可能因为物理系统的限制不能运行，这种情况下会转换成一个可运行的等价线路运行
    private String[][] finalCircuit;
    // 任务运行结果，长度：2^比特数, null 表示线路无法运行或运行错误
    private float[] result;

    /* 返回实际输出的控制波形作为额外数据，null 表示没有这个数据
        * 3x比特数 行：
        * waveforms[0]: 第一个比特 xy I 波形
        * waveforms[0]: 第一个比特 xy Q 波形
        * waveforms[0]: 第一个比特 xy Z 波形
        * waveforms[0]: 第二个比特 xy I 波形
        * ...
        */
    private float[][] waveforms;
    // 线路无法运行或运行错误情况下的错误信息，正常运行为 null
    private String errorMsg;

    public QuantumResult(){}

    public long getTaskId() {
        return taskId;
    }

    public void setTaskId(long taskId) {
        this.taskId = taskId;
    }

    public String[][] getFinalCircuit() {
        return finalCircuit;
    }

    public void setFinalCircuit(String[][] finalCircuit) {
        this.finalCircuit = finalCircuit;
    }

    public float[] getResult() {
        return result;
    }

    public void setResult(float[] result) {
        this.result = result;
    }

    public float[][] getWaveforms() {
        return waveforms;
    }

    public void setWaveforms(float[][] waveforms) {
        this.waveforms = waveforms;
    }

    public String getErrorMsg() {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }
}
