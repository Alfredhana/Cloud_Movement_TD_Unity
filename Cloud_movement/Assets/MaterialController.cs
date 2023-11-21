using System.Collections.Generic;
using UnityEngine;

public class MaterialController : MonoBehaviour
{
    public List<Texture2D> imgs; // List of PNG images

    // Start is called before the first frame update
    void Start()
    {
        LoadImagesToClouds();
    }

    void LoadImagesToClouds()
    {
        // Check if the number of provided images matches the number of GameObjects
        if (imgs.Count != 24)
        {
            Debug.LogError("The number of provided images does not match the number of GameObjects.");
            return;
        }
        GameObject clouds = GameObject.Find("clouds");
		Renderer[] cloudRenderers = clouds.GetComponentsInChildren<Renderer>();
		
        // Loop through the GameObjects and assign images to their materials
		int i = 0;
        foreach (Renderer cloudRenderer in cloudRenderers)
		{
            if (cloudRenderer != null)
            {
                // Check if the current GameObject has a material
                Material material = cloudRenderer.material;
                if (material != null)
                {
                    // Assign the image to the material texture
                    material.mainTexture = imgs[i];
                }
                else
                {
                    Debug.LogError("GameObject " + (i + 1) + " does not have a material.");
                }
            }
            else
            {
                Debug.LogError("GameObject " + (i + 1) + " does not have a renderer.");
            }
			i++;
        }
    }
}