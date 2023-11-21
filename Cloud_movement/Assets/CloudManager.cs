using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CloudManager : MonoBehaviour
{
    private Dictionary<GameObject, float> cloudData;
    float canvasWidth;
    //private float smoothTime = 0.8f;
    public float randXRange;

    // Start is called before the first frame update
    void Start()
    {
        cloudData = new Dictionary<GameObject, float>();

        // Find the Canvas named "clouds"
		GameObject groundObject = GameObject.Find("ground");
		Renderer groundRenderer = groundObject.GetComponent<Renderer>();
		canvasWidth = groundRenderer.bounds.size.x / 3;
		
        GameObject cloudsObject  = GameObject.Find("clouds");
        if (cloudsObject != null)
        {
            Transform[] cloudCubes = cloudsObject.GetComponentsInChildren<Transform>();
            int i = cloudCubes.Length / 2;
            foreach (Transform cloudCubeTransform in cloudCubes)
            {
                // Filter out the clouds object itself
                if (cloudCubeTransform != cloudsObject.transform)
                {
                    GameObject cloudCube = cloudCubeTransform.gameObject;
                    float zDirection = i++;
                    cloudData.Add(cloudCube, zDirection);

                    // Assign z direction based on cloud index
                    float randomX = Random.Range(-randXRange, randXRange);
                    Vector3 newPosition = cloudCube.transform.localPosition;
                    newPosition.x += randomX;
                    newPosition.z = zDirection;
                    cloudCube.transform.localPosition = newPosition;
                }
            }
        }
    }

    // Update is called once per frame
    public void UpdateCloud(Vector3 dir)
    {
        foreach (KeyValuePair<GameObject, float> cloudPair in cloudData)
        {
            GameObject cloudCube = cloudPair.Key;
            float zDirection = cloudPair.Value;

            // Calculate the new position of the cloud
            Vector3 newPosition = cloudCube.transform.localPosition;
            newPosition.x = dir.x * zDirection * Mathf.Clamp(zDirection, 0.1f, 1.5f);

            // Keep the cloud within the camera's view
            float halfCanvasWidth = canvasWidth / 2;
            float cloudWidth = cloudCube.GetComponent<Renderer>().bounds.size.x / 2f;
			

            float minX = -halfCanvasWidth + cloudWidth;
            float maxX = halfCanvasWidth - cloudWidth;
            newPosition.x = Mathf.Clamp(newPosition.x, minX, maxX);

            // Update the cloud's position
            cloudCube.transform.localPosition = newPosition;
        }
    }
}