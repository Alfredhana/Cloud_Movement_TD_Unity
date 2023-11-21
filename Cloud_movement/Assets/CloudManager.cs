using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CloudManager : MonoBehaviour
{
    private Dictionary<Image, float> cloudData;
    float canvasWidth;
    float canvasGap;

    // Start is called before the first frame update
    void Start()
    {
        cloudData = new Dictionary<Image, float>();

        // Find the Canvas named "clouds"
        GameObject cloudsCanvas = GameObject.Find("clouds");
        if (cloudsCanvas != null)
        {
            // Get all Image components under the Canvas and add them to the dictionary
            Image[] cloudImages = cloudsCanvas.GetComponentsInChildren<Image>();
            RectTransform canvasRect = cloudsCanvas.GetComponent<RectTransform>();
            canvasWidth = canvasRect.rect.width;
            //canvasGap = canvasWidth / cloudImages.Length / 4f;
            int i = cloudImages.Length / 2 - cloudImages.Length;
            foreach (Image cloud in cloudImages)
            {
                // float randomNumber;
                // do
                // {
                //     randomNumber = Random.Range(1f, 100f);
                // }
                // while (cloudData.ContainsValue(randomNumber)); // Check for duplicates
                //float zDirection = cloud.transform.GetSiblingIndex() + 1;
                float zDirection = i++;
                //float randomNumber = Mathf.Lerp(1, 10, zDirection);

                cloudData.Add(cloud, zDirection);

                // Assign z direction based on cloud index
                
                float randomX = Random.Range(-canvasWidth/2f, canvasWidth/2f);
                cloud.transform.localPosition = new Vector3(cloud.transform.localPosition.x + randomX, cloud.transform.localPosition.y, zDirection);
            }
        }
    }

    // Map the xDir value from the range [0, 1] to the desired movement range
    float movementRange = 1f; // Adjust this to fit your desired range

    // Update is called once per frame
    public void UpdateCloud(float xDir)
    {

        foreach (KeyValuePair<Image, float> cloudPair in cloudData)
        {
            Image cloud = cloudPair.Key;
            float randomNumber = cloudPair.Value;

            // Map the xDir value from the range [-1, 1] to the range [0, canvasWidth]
            float targetX = Remap(xDir, -1f, 1f, 0, canvasWidth);

            // Set the cloud's position based on the mapped x value
            Vector3 newPosition = new Vector3(targetX + randomNumber * movementRange, cloud.transform.position.y, cloud.transform.position.z);
            cloud.transform.position = newPosition;
        }
    }

    float Remap(float value, float fromMin, float fromMax, float toMin, float toMax)
    {
        return (value - fromMin) * (toMax - toMin) / (fromMax - fromMin) + toMin;
    }
}