using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TVNoisePP : MonoBehaviour
{
    public Shader shader1;
    public Shader shader2;
    private Material mat1, mat2;
    public RenderTexture rt;

    public Slider smallNoiseScale, linesScale, maskScale, smallNoiseAmmount, linesAmmount, maskAmmount;
    // Start is called before the first frame update
    void Start()
    {
        mat1 = new Material(shader1);
        mat2 = new Material(shader2);
    }

    // Update is called once per frame
    void Update()
    {
        mat1.SetFloat("_smallNoiseScale", smallNoiseScale.value);
        mat1.SetFloat("_linesScale", linesScale.value);
        mat1.SetFloat("_maskScale", maskScale.value);
        mat1.SetFloat("_smallNoiseAmmount", smallNoiseAmmount.value);
        mat1.SetFloat("_linesAmmount", linesAmmount.value);
        mat1.SetFloat("_maskAmmount", maskAmmount.value);
        mat2.SetFloat("_intensity", 0.0144f);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture rt = new RenderTexture(Screen.width, Screen.height,16, RenderTextureFormat.ARGB32);
        Graphics.Blit(source, rt, mat2);
        Graphics.Blit(rt, destination, mat1);
    }
}
